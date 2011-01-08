@ECHO OFF
if not exist testdata svn co http://svn.python.org/projects/python/branches/py3k/Lib/test/decimaltestdata && move decimaltestdata testdata
if not exist testdata\baseconv.decTest copy /y testdata_dist\* testdata
