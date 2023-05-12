﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;

namespace IronWren.AutoMapper
{
    /// <summary>
    /// Contains the bindings generated by the AutoMapper.
    /// </summary>
    internal sealed class ForeignClass
    {
        private static readonly MethodInfo genericGetSlotForeign = typeof(WrenVM).GetTypeInfo()
                    .GetDeclaredMethods("GetSlotForeign").Single(method => method.IsGenericMethod);

        private static readonly ConstantExpression slot = Expression.Constant(0);
        private static readonly ParameterExpression vmParam = Expression.Parameter(typeof(WrenVM));

        private readonly WrenForeignClassMethods classMethods;

        private readonly Dictionary<string, WrenForeignMethod> functions = new Dictionary<string, WrenForeignMethod>();

        private readonly MethodCallExpression getSlotForeign;

        private readonly TypeInfo target;

        /// <summary>
        /// Gets the <see cref="WrenForeignMethod"/>s that are part of the class.
        /// <para/>
        /// Includes everything (methods, properties, indexers).
        /// </summary>
        public ReadOnlyDictionary<string, WrenForeignMethod> Functions { get; }

        /// <summary>
        /// Gets the name of the class on the Wren side.
        /// </summary>
        public string Name { get; }

        /// <summary>
        /// Gets the Wren source code for the foreign class.
        /// </summary>
        public string Source { get; }

        public ForeignClass(Type target)
        {
            this.target = target.GetTypeInfo();

            // Abstract + Sealed = Static
            if (this.target.IsAbstract && !this.target.IsSealed)
                ThrowHelper.ThrowArgumentException("The target type can't be abstract!", nameof(target));

            if (this.target.ContainsGenericParameters)
                ThrowHelper.ThrowArgumentException("The target type can't have remaining generic parameters!", nameof(target));

            getSlotForeign = Expression.Call(vmParam, genericGetSlotForeign.MakeGenericMethod(target), slot);

            Functions = new ReadOnlyDictionary<string, WrenForeignMethod>(functions);

            var classAttribute = this.target.GetCustomAttribute<WrenClassAttribute>();
            Name = classAttribute?.Name ?? this.target.Name;

            classMethods = new WrenForeignClassMethods
            {
                Allocate = WrenConstructorAttribute.MakeAllocator(target),
                Finalize = WrenFinalizerAttribute.MakeFinalizer(target)
            };

            Source = generateSource();
        }

        internal WrenForeignClassMethods Bind()
        {
            return classMethods;
        }

        private void addSignature(string signature, MethodInfo method)
        {
            if (functions.ContainsKey(signature))
                ThrowHelper.ThrowSignatureExistsException(signature, target.AsType());

            functions.Add(signature, getInvoker(method));
        }

        private string generateSource()
        {
            var sourceBuilder = new StringBuilder();

            sourceBuilder.AppendLine($"foreign class {Name} {{");

            makeConstructors(sourceBuilder);
            makeProperties(sourceBuilder);
            makeIndexers(sourceBuilder);
            makeMethods(sourceBuilder);

            foreach (var field in WrenCodeAttribute.GetFields(target.AsType()))
                sourceBuilder.AppendLine((string)field.GetValue(null));

            sourceBuilder.AppendLine("}");

            return sourceBuilder.ToString();
        }

        private WrenForeignMethod getInvoker(MethodInfo method)
        {
            if (method.IsStatic)
                return (WrenForeignMethod)method.CreateDelegate(typeof(WrenForeignMethod));

            // vm => vm.GetSlotForeign<TTarget>(0).[method](vm)
            return Expression.Lambda<WrenForeignMethod>(
                Expression.Call(getSlotForeign, method, vmParam),
                vmParam).Compile();
        }

        private void makeConstructors(StringBuilder sourceBuilder)
        {
            var constructor = WrenConstructorAttribute.GetConstructorDetails(target.AsType());

            if (constructor == null)
                return;

            foreach (var constructorAttribute in constructor.Attributes)
                sourceBuilder.AppendLine($@"{Definition.MakeConstructor(constructorAttribute.Arguments)} {{{(
                    constructorAttribute.HasCode ? $"\n{constructorAttribute.GetCode(target.AsType())}\n" : " ")}}}");
        }

        private void makeIndexers(StringBuilder sourceBuilder)
        {
            foreach (var method in WrenIndexerAttribute.GetMethodDetails(target.AsType()))
            {
                var signature = Signature.MakeIndexer(method.Attribute.Type, method.Attribute.Arguments.Length);
                addSignature(signature, method.Info);

                sourceBuilder.AppendLine(Definition.MakeIndexer(method.Info));
            }
        }

        private void makeMethods(StringBuilder sourceBuilder)
        {
            foreach (var method in WrenMethodAttribute.GetMethodDetails(target.AsType()))
            {
                var signature = Signature.MakeMethod(method.Attribute.Name, method.Attribute.Arguments.Length);
                addSignature(signature, method.Info);

                sourceBuilder.AppendLine(Definition.MakeMethod(method.Info));
            }
        }

        private void makeProperties(StringBuilder sourceBuilder)
        {
            foreach (var method in WrenPropertyAttribute.GetMethodDetails(target.AsType()))
            {
                var signature = Signature.MakeProperty(method.Attribute.Type, method.Attribute.Name);
                addSignature(signature, method.Info);

                sourceBuilder.AppendLine(Definition.MakeProperty(method.Info));
            }
        }
    }
}