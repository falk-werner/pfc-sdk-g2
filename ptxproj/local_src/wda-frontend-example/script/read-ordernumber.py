#/usr/bin/env python3

from ctypes import *

cdll.LoadLibrary("libparamcom_c.so")
libparamcom_c = CDLL("libparamcom_c.so")
libparamcom_c.wda_value_getstring.restype = c_char_p

class WdaProxy:
    def __init__(self):
        self.proxy = libparamcom_c.wda_proxy_create(b"python3")
    
    def __del__(self):
        libparamcom_c.wda_proxy_release(self.proxy)
    
    def read_str_sync(self, path):
        value = libparamcom_c.wda_proxy_read_sync(self.proxy, path.encode(), 0)
        if 0 == value:
            return ""
        text = libparamcom_c.wda_value_getstring(value)
        return text.decode()

proxy = WdaProxy()
print(proxy.read_str_sync("Identity/Ordernumber"))
