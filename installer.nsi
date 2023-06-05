; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Sunaba"
!define PRODUCT_VERSION "0.5.0"
!define PRODUCT_PUBLISHER "mintkat"
!define PRODUCT_WEB_SITE "https://thesunabaproject.github.io/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\Sunaba.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "assets\icon.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
#!define MUI_WELCOMEFINISHPAGE_BITMAP "assets\welcome.bmp"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "licenses.txt"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\Sunaba.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "bin\output.exe"
InstallDir "$PROGRAMFILES\Sunaba"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section "Sunaba" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "binWin32\Sunaba.exe"
  CreateDirectory "$SMPROGRAMS\Sunaba"
  CreateShortCut "$SMPROGRAMS\Sunaba\Sunaba.lnk" "$INSTDIR\Sunaba.exe"
  CreateShortCut "$DESKTOP\Sunaba.lnk" "$INSTDIR\Sunaba.exe"
  CreateShortCut "$STARTMENU\Sunaba.lnk" "$INSTDIR\Sunaba.exe"
  File "binWin32\Sunaba.console.exe"
  File "binWin32\Sunaba.pck"
  File "binWin32\godot-jolt_windows-x86.dll"
  SetOutPath "$INSTDIR\data_Sunaba_x86_32"
  SetOverwrite try
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-console-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-console-l1-2-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-datetime-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-debug-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-errorhandling-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-fibers-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-file-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-file-l1-2-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-file-l2-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-handle-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-heap-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-interlocked-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-libraryloader-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-localization-l1-2-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-memory-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-namedpipe-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-processenvironment-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-processthreads-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-processthreads-l1-1-1.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-profile-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-rtlsupport-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-string-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-synch-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-synch-l1-2-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-sysinfo-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-timezone-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-core-util-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\API-MS-Win-core-xstate-l2-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-conio-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-convert-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-environment-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-filesystem-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-heap-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-locale-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-math-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-multibyte-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-private-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-process-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-runtime-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-stdio-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-string-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-time-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\api-ms-win-crt-utility-l1-1-0.dll"
  File "binWin32\data_Sunaba_x86_32\clretwrc.dll"
  File "binWin32\data_Sunaba_x86_32\clrjit.dll"
  File "binWin32\data_Sunaba_x86_32\coreclr.dll"
  File "binWin32\data_Sunaba_x86_32\createdump.exe"
  File "binWin32\data_Sunaba_x86_32\dbgshim.dll"
  File "binWin32\data_Sunaba_x86_32\GodotSharp.dll"
  File "binWin32\data_Sunaba_x86_32\hostfxr.dll"
  File "binWin32\data_Sunaba_x86_32\hostpolicy.dll"
  File "binWin32\data_Sunaba_x86_32\Microsoft.CSharp.dll"
  File "binWin32\data_Sunaba_x86_32\Microsoft.DiaSymReader.Native.x86.dll"
  File "binWin32\data_Sunaba_x86_32\Microsoft.VisualBasic.Core.dll"
  File "binWin32\data_Sunaba_x86_32\Microsoft.VisualBasic.dll"
  File "binWin32\data_Sunaba_x86_32\Microsoft.Win32.Primitives.dll"
  File "binWin32\data_Sunaba_x86_32\Microsoft.Win32.Registry.dll"
  File "binWin32\data_Sunaba_x86_32\MoonSharp.Interpreter.dll"
  File "binWin32\data_Sunaba_x86_32\mscordaccore.dll"
  #File "binWin32\data_Sunaba_x86_32\mscordaccore_x86_x86_6.0.1523.11507.dll"
  File "binWin32\data_Sunaba_x86_32\mscordbi.dll"
  File "binWin32\data_Sunaba_x86_32\mscorlib.dll"
  File "binWin32\data_Sunaba_x86_32\mscorrc.dll"
  File "binWin32\data_Sunaba_x86_32\msquic.dll"
  File "binWin32\data_Sunaba_x86_32\netstandard.dll"
  File "binWin32\data_Sunaba_x86_32\Sunaba.deps.json"
  File "binWin32\data_Sunaba_x86_32\Sunaba.dll"
  File "binWin32\data_Sunaba_x86_32\Sunaba.pdb"
  File "binWin32\data_Sunaba_x86_32\Sunaba.runtimeconfig.json"
  File "binWin32\data_Sunaba_x86_32\System.AppContext.dll"
  File "binWin32\data_Sunaba_x86_32\System.Buffers.dll"
  File "binWin32\data_Sunaba_x86_32\System.Collections.Concurrent.dll"
  File "binWin32\data_Sunaba_x86_32\System.Collections.dll"
  File "binWin32\data_Sunaba_x86_32\System.Collections.Immutable.dll"
  File "binWin32\data_Sunaba_x86_32\System.Collections.NonGeneric.dll"
  File "binWin32\data_Sunaba_x86_32\System.Collections.Specialized.dll"
  File "binWin32\data_Sunaba_x86_32\System.ComponentModel.Annotations.dll"
  File "binWin32\data_Sunaba_x86_32\System.ComponentModel.DataAnnotations.dll"
  File "binWin32\data_Sunaba_x86_32\System.ComponentModel.dll"
  File "binWin32\data_Sunaba_x86_32\System.ComponentModel.EventBasedAsync.dll"
  File "binWin32\data_Sunaba_x86_32\System.ComponentModel.Primitives.dll"
  File "binWin32\data_Sunaba_x86_32\System.ComponentModel.TypeConverter.dll"
  File "binWin32\data_Sunaba_x86_32\System.Configuration.dll"
  File "binWin32\data_Sunaba_x86_32\System.Console.dll"
  File "binWin32\data_Sunaba_x86_32\System.Core.dll"
  File "binWin32\data_Sunaba_x86_32\System.Data.Common.dll"
  File "binWin32\data_Sunaba_x86_32\System.Data.DataSetExtensions.dll"
  File "binWin32\data_Sunaba_x86_32\System.Data.dll"
  File "binWin32\data_Sunaba_x86_32\System.Diagnostics.Contracts.dll"
  File "binWin32\data_Sunaba_x86_32\System.Diagnostics.Debug.dll"
  File "binWin32\data_Sunaba_x86_32\System.Diagnostics.DiagnosticSource.dll"
  File "binWin32\data_Sunaba_x86_32\System.Diagnostics.FileVersionInfo.dll"
  File "binWin32\data_Sunaba_x86_32\System.Diagnostics.Process.dll"
  File "binWin32\data_Sunaba_x86_32\System.Diagnostics.StackTrace.dll"
  File "binWin32\data_Sunaba_x86_32\System.Diagnostics.TextWriterTraceListener.dll"
  File "binWin32\data_Sunaba_x86_32\System.Diagnostics.Tools.dll"
  File "binWin32\data_Sunaba_x86_32\System.Diagnostics.TraceSource.dll"
  File "binWin32\data_Sunaba_x86_32\System.Diagnostics.Tracing.dll"
  File "binWin32\data_Sunaba_x86_32\System.dll"
  File "binWin32\data_Sunaba_x86_32\System.Drawing.dll"
  File "binWin32\data_Sunaba_x86_32\System.Drawing.Primitives.dll"
  File "binWin32\data_Sunaba_x86_32\System.Dynamic.Runtime.dll"
  File "binWin32\data_Sunaba_x86_32\System.Formats.Asn1.dll"
  File "binWin32\data_Sunaba_x86_32\System.Globalization.Calendars.dll"
  File "binWin32\data_Sunaba_x86_32\System.Globalization.dll"
  File "binWin32\data_Sunaba_x86_32\System.Globalization.Extensions.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.Compression.Brotli.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.Compression.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.Compression.FileSystem.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.Compression.Native.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.Compression.ZipFile.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.FileSystem.AccessControl.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.FileSystem.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.FileSystem.DriveInfo.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.FileSystem.Primitives.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.FileSystem.Watcher.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.IsolatedStorage.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.MemoryMappedFiles.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.Pipes.AccessControl.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.Pipes.dll"
  File "binWin32\data_Sunaba_x86_32\System.IO.UnmanagedMemoryStream.dll"
  File "binWin32\data_Sunaba_x86_32\System.Linq.dll"
  File "binWin32\data_Sunaba_x86_32\System.Linq.Expressions.dll"
  File "binWin32\data_Sunaba_x86_32\System.Linq.Parallel.dll"
  File "binWin32\data_Sunaba_x86_32\System.Linq.Queryable.dll"
  File "binWin32\data_Sunaba_x86_32\System.Memory.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.Http.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.Http.Json.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.HttpListener.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.Mail.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.NameResolution.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.NetworkInformation.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.Ping.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.Primitives.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.Quic.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.Requests.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.Security.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.ServicePoint.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.Sockets.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.WebClient.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.WebHeaderCollection.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.WebProxy.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.WebSockets.Client.dll"
  File "binWin32\data_Sunaba_x86_32\System.Net.WebSockets.dll"
  File "binWin32\data_Sunaba_x86_32\System.Numerics.dll"
  File "binWin32\data_Sunaba_x86_32\System.Numerics.Vectors.dll"
  File "binWin32\data_Sunaba_x86_32\System.ObjectModel.dll"
  File "binWin32\data_Sunaba_x86_32\System.Private.CoreLib.dll"
  File "binWin32\data_Sunaba_x86_32\System.Private.DataContractSerialization.dll"
  File "binWin32\data_Sunaba_x86_32\System.Private.Uri.dll"
  File "binWin32\data_Sunaba_x86_32\System.Private.Xml.dll"
  File "binWin32\data_Sunaba_x86_32\System.Private.Xml.Linq.dll"
  File "binWin32\data_Sunaba_x86_32\System.Reflection.DispatchProxy.dll"
  File "binWin32\data_Sunaba_x86_32\System.Reflection.dll"
  File "binWin32\data_Sunaba_x86_32\System.Reflection.Emit.dll"
  File "binWin32\data_Sunaba_x86_32\System.Reflection.Emit.ILGeneration.dll"
  File "binWin32\data_Sunaba_x86_32\System.Reflection.Emit.Lightweight.dll"
  File "binWin32\data_Sunaba_x86_32\System.Reflection.Extensions.dll"
  File "binWin32\data_Sunaba_x86_32\System.Reflection.Metadata.dll"
  File "binWin32\data_Sunaba_x86_32\System.Reflection.Primitives.dll"
  File "binWin32\data_Sunaba_x86_32\System.Reflection.TypeExtensions.dll"
  File "binWin32\data_Sunaba_x86_32\System.Resources.Reader.dll"
  File "binWin32\data_Sunaba_x86_32\System.Resources.ResourceManager.dll"
  File "binWin32\data_Sunaba_x86_32\System.Resources.Writer.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.CompilerServices.Unsafe.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.CompilerServices.VisualC.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.Extensions.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.Handles.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.InteropServices.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.InteropServices.RuntimeInformation.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.Intrinsics.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.Loader.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.Numerics.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.Serialization.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.Serialization.Formatters.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.Serialization.Json.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.Serialization.Primitives.dll"
  File "binWin32\data_Sunaba_x86_32\System.Runtime.Serialization.Xml.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.AccessControl.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.Claims.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.Cryptography.Algorithms.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.Cryptography.Cng.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.Cryptography.Csp.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.Cryptography.Encoding.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.Cryptography.OpenSsl.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.Cryptography.Primitives.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.Cryptography.X509Certificates.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.Principal.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.Principal.Windows.dll"
  File "binWin32\data_Sunaba_x86_32\System.Security.SecureString.dll"
  File "binWin32\data_Sunaba_x86_32\System.ServiceModel.Web.dll"
  File "binWin32\data_Sunaba_x86_32\System.ServiceProcess.dll"
  File "binWin32\data_Sunaba_x86_32\System.Text.Encoding.CodePages.dll"
  File "binWin32\data_Sunaba_x86_32\System.Text.Encoding.dll"
  File "binWin32\data_Sunaba_x86_32\System.Text.Encoding.Extensions.dll"
  File "binWin32\data_Sunaba_x86_32\System.Text.Encodings.Web.dll"
  File "binWin32\data_Sunaba_x86_32\System.Text.Json.dll"
  File "binWin32\data_Sunaba_x86_32\System.Text.RegularExpressions.dll"
  File "binWin32\data_Sunaba_x86_32\System.Threading.Channels.dll"
  File "binWin32\data_Sunaba_x86_32\System.Threading.dll"
  File "binWin32\data_Sunaba_x86_32\System.Threading.Overlapped.dll"
  File "binWin32\data_Sunaba_x86_32\System.Threading.Tasks.Dataflow.dll"
  File "binWin32\data_Sunaba_x86_32\System.Threading.Tasks.dll"
  File "binWin32\data_Sunaba_x86_32\System.Threading.Tasks.Extensions.dll"
  File "binWin32\data_Sunaba_x86_32\System.Threading.Tasks.Parallel.dll"
  File "binWin32\data_Sunaba_x86_32\System.Threading.Thread.dll"
  File "binWin32\data_Sunaba_x86_32\System.Threading.ThreadPool.dll"
  File "binWin32\data_Sunaba_x86_32\System.Threading.Timer.dll"
  File "binWin32\data_Sunaba_x86_32\System.Transactions.dll"
  File "binWin32\data_Sunaba_x86_32\System.Transactions.Local.dll"
  File "binWin32\data_Sunaba_x86_32\System.ValueTuple.dll"
  File "binWin32\data_Sunaba_x86_32\System.Web.dll"
  File "binWin32\data_Sunaba_x86_32\System.Web.HttpUtility.dll"
  File "binWin32\data_Sunaba_x86_32\System.Windows.dll"
  File "binWin32\data_Sunaba_x86_32\System.Xml.dll"
  File "binWin32\data_Sunaba_x86_32\System.Xml.Linq.dll"
  File "binWin32\data_Sunaba_x86_32\System.Xml.ReaderWriter.dll"
  File "binWin32\data_Sunaba_x86_32\System.Xml.Serialization.dll"
  File "binWin32\data_Sunaba_x86_32\System.Xml.XDocument.dll"
  File "binWin32\data_Sunaba_x86_32\System.Xml.XmlDocument.dll"
  File "binWin32\data_Sunaba_x86_32\System.Xml.XmlSerializer.dll"
  File "binWin32\data_Sunaba_x86_32\System.Xml.XPath.dll"
  File "binWin32\data_Sunaba_x86_32\System.Xml.XPath.XDocument.dll"
  File "binWin32\data_Sunaba_x86_32\ucrtbase.dll"
  File "binWin32\data_Sunaba_x86_32\WindowsBase.dll"
  File "binWin32\data_Sunaba_x86_32\Jint.dll"
  File "binWin32\data_Sunaba_x86_32\Esprima.dll"
SectionEnd

Section "Maps" SEC02
  SetOutPath "$INSTDIR"
  File "maps\base.map"
  File "maps\city.map"
  File "maps\construct.map"
  File "maps\dm_test.map"
  File "maps\dust2.map"
  File "maps\musictest1.map"
  File "maps\musictest2.map"
  File "maps\npctest.map"
  File "maps\paradise.map"
  File "maps\range.map"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\Sunaba\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\Sunaba\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\Sunaba.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\Sunaba.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} ""
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name)" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\txtscale.txt"
  Delete "$INSTDIR\range.map.import"
  Delete "$INSTDIR\range.map"
  Delete "$INSTDIR\paradise.map.import"
  Delete "$INSTDIR\paradise.map"
  Delete "$INSTDIR\npctest.map"
  Delete "$INSTDIR\musictest2.map"
  Delete "$INSTDIR\musictest1.map"
  Delete "$INSTDIR\dust2.map.import"
  Delete "$INSTDIR\dust2.map"
  Delete "$INSTDIR\dm_test.map.import"
  Delete "$INSTDIR\dm_test.map"
  Delete "$INSTDIR\construct.map.import"
  Delete "$INSTDIR\construct.map"
  Delete "$INSTDIR\city.map.import"
  Delete "$INSTDIR\city.map"
  Delete "$INSTDIR\base.map.import"
  Delete "$INSTDIR\base.map"
  Delete "$INSTDIR\data_Sunaba_x86_32\WindowsBase.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\ucrtbase.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Xml.XPath.XDocument.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Xml.XPath.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Xml.XmlSerializer.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Xml.XmlDocument.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Xml.XDocument.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Xml.Serialization.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Xml.ReaderWriter.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Xml.Linq.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Xml.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Windows.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Web.HttpUtility.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Web.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.ValueTuple.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Transactions.Local.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Transactions.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Threading.Timer.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Threading.ThreadPool.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Threading.Thread.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Threading.Tasks.Parallel.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Threading.Tasks.Extensions.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Threading.Tasks.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Threading.Tasks.Dataflow.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Threading.Overlapped.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Threading.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Threading.Channels.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Text.RegularExpressions.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Text.Json.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Text.Encodings.Web.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Text.Encoding.Extensions.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Text.Encoding.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Text.Encoding.CodePages.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.ServiceProcess.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.ServiceModel.Web.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.SecureString.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.Principal.Windows.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.Principal.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.Cryptography.X509Certificates.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.Cryptography.Primitives.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.Cryptography.OpenSsl.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.Cryptography.Encoding.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.Cryptography.Csp.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.Cryptography.Cng.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.Cryptography.Algorithms.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.Claims.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Security.AccessControl.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.Serialization.Xml.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.Serialization.Primitives.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.Serialization.Json.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.Serialization.Formatters.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.Serialization.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.Numerics.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.Loader.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.Intrinsics.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.InteropServices.RuntimeInformation.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.InteropServices.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.Handles.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.Extensions.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.CompilerServices.VisualC.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Runtime.CompilerServices.Unsafe.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Resources.Writer.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Resources.ResourceManager.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Resources.Reader.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Reflection.TypeExtensions.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Reflection.Primitives.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Reflection.Metadata.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Reflection.Extensions.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Reflection.Emit.Lightweight.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Reflection.Emit.ILGeneration.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Reflection.Emit.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Reflection.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Reflection.DispatchProxy.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Private.Xml.Linq.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Private.Xml.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Private.Uri.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Private.DataContractSerialization.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Private.CoreLib.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.ObjectModel.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Numerics.Vectors.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Numerics.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.WebSockets.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.WebSockets.Client.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.WebProxy.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.WebHeaderCollection.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.WebClient.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.Sockets.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.ServicePoint.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.Security.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.Requests.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.Quic.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.Primitives.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.Ping.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.NetworkInformation.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.NameResolution.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.Mail.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.HttpListener.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.Http.Json.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.Http.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Net.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Memory.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Linq.Queryable.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Linq.Parallel.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Linq.Expressions.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Linq.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.UnmanagedMemoryStream.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.Pipes.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.Pipes.AccessControl.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.MemoryMappedFiles.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.IsolatedStorage.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.FileSystem.Watcher.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.FileSystem.Primitives.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.FileSystem.DriveInfo.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.FileSystem.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.FileSystem.AccessControl.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.Compression.ZipFile.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.Compression.Native.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.Compression.FileSystem.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.Compression.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.IO.Compression.Brotli.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Globalization.Extensions.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Globalization.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Globalization.Calendars.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Formats.Asn1.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Dynamic.Runtime.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Drawing.Primitives.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Drawing.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Diagnostics.Tracing.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Diagnostics.TraceSource.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Diagnostics.Tools.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Diagnostics.TextWriterTraceListener.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Diagnostics.StackTrace.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Diagnostics.Process.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Diagnostics.FileVersionInfo.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Diagnostics.DiagnosticSource.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Diagnostics.Debug.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Diagnostics.Contracts.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Data.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Data.DataSetExtensions.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Data.Common.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Core.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Console.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Configuration.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.ComponentModel.TypeConverter.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.ComponentModel.Primitives.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.ComponentModel.EventBasedAsync.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.ComponentModel.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.ComponentModel.DataAnnotations.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.ComponentModel.Annotations.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Collections.Specialized.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Collections.NonGeneric.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Collections.Immutable.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Collections.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Collections.Concurrent.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.Buffers.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\System.AppContext.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\Sunaba.runtimeconfig.json"
  Delete "$INSTDIR\data_Sunaba_x86_32\Sunaba.pdb"
  Delete "$INSTDIR\data_Sunaba_x86_32\Sunaba.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\Sunaba.deps.json"
  Delete "$INSTDIR\data_Sunaba_x86_32\netstandard.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\msquic.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\mscorrc.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\mscorlib.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\mscordbi.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\mscordaccore_x86_x86_6.0.1523.11507.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\mscordaccore.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\MoonSharp.Interpreter.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\Microsoft.Win32.Registry.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\Microsoft.Win32.Primitives.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\Microsoft.VisualBasic.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\Microsoft.VisualBasic.Core.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\Microsoft.DiaSymReader.Native.x86.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\Microsoft.CSharp.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\hostpolicy.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\hostfxr.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\GodotSharp.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\dbgshim.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\createdump.exe"
  Delete "$INSTDIR\data_Sunaba_x86_32\coreclr.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\clrjit.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\clretwrc.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-utility-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-time-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-string-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-stdio-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-runtime-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-process-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-private-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-multibyte-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-math-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-locale-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-heap-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-filesystem-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-environment-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-convert-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-crt-conio-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\API-MS-Win-core-xstate-l2-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-util-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-timezone-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-sysinfo-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-synch-l1-2-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-synch-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-string-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-rtlsupport-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-profile-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-processthreads-l1-1-1.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-processthreads-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-processenvironment-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-namedpipe-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-memory-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-localization-l1-2-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-libraryloader-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-interlocked-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-heap-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-handle-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-file-l2-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-file-l1-2-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-file-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-fibers-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-errorhandling-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-debug-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-datetime-l1-1-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-console-l1-2-0.dll"
  Delete "$INSTDIR\data_Sunaba_x86_32\api-ms-win-core-console-l1-1-0.dll"
  Delete "$INSTDIR\Sunaba.pck"
  Delete "$INSTDIR\Sunaba.console.exe"
  Delete "$INSTDIR\Sunaba.exe"

  Delete "$SMPROGRAMS\Sunaba\Uninstall.lnk"
  Delete "$SMPROGRAMS\Sunaba\Website.lnk"
  Delete "$STARTMENU\Sunaba.lnk"
  Delete "$DESKTOP\Sunaba.lnk"
  Delete "$SMPROGRAMS\Sunaba\Sunaba.lnk"

  RMDir "$SMPROGRAMS\Sunaba"
  RMDir "$INSTDIR\data_Sunaba_x86_32"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
