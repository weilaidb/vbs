' 功能：监听某目录下coffee文件 若有改动  执行dos命令 编译

Set wi = CreateObject("WindowsInstaller.Installer")
Set fos = CreateObject("Scripting.Filesystemobject")
Set fileMap = CreateObject("Scripting.Dictionary")
Set cmd = CreateObject("wscript.shell")

' 匹配文件名正则
Set fileNameReg = New RegExp
fileNameReg.Pattern = ".*\.vbs$"
fileNameReg.IgnoreCase = false

' 编译程序所在的位置
coffeeCmd = "E:\Qtexample\git\vbs -cm "
' WSH.Echo "print your message here"
' 监听的目录  没有监听其子目录   需要的话使用递归扩展
' dirPath = WScript.Arguments(0)
dirPath = "E:\Qtexample\git\vbs"

run 

Sub run ()
	' 无限执行  如要退出 请结束进程  或加结束条件 如检测到某个文件存在或修改则退出
	while true
		scanDirectory
		WScript.Sleep 1000
	Wend
End Sub

' 扫描目录
Sub scanDirectory ()
	Set folder = fos.getFolder(dirPath)
	
	For Each f In folder.Files
		If fileNameReg.Test(f.name) Then
			tmpMD5 = GetFileHash(f.path)
			If fileMap.Exists(f.path) Then
			 	If tmpMD5 <> fileMap.Item(f.path) Then
			 		' 静默执行dos命令
			 		cmd.Run("%comspec% /c " & coffeeCmd & f.path), 0, false
			 		fileMap.Remove(f.path)
			 		fileMap.Add f.path, tmpMD5
					WSH.Echo "print your message here"
			 	End If
			Else
				fileMap.Add f.path, GetFileHash(f.path)
			End If 
		End If
	Next
End Sub

' 获取md5  代码来自网络
Function GetFileHash(file_name)
	Dim file_hash
	Dim hash_value
	Dim i
	Set file_hash = wi.FileHash(file_name, 0)
	hash_value = ""
	For i = 1 To file_hash.FieldCount
		hash_value = hash_value & BigEndianHex(file_hash.IntegerData(i))
	Next

	GetFileHash = hash_value
	Set file_hash = Nothing
End Function

Function BigEndianHex(Int)
	Dim result
	Dim b1, b2, b3, b4
	result = Hex(Int)
	' MsgBox result
	b1 = Mid(result, 7, 2)
	b2 = Mid(result, 5, 2)
	b3 = Mid(result, 3, 2)
	b4 = Mid(result, 1, 2)

	BigEndianHex = b1 & b2 & b3 & b4
End Function

