--#ENDPOINT GET /_init
local ret1 = User.createRole({role_id = "engineer", parameter = {{name = "sn"}}})
local ret2 = User.createRole({role_id = "normal", parameter = {{name = "sn"}}})
local ret = ret1.status_code ~= nil and ret1 or nil
if ret == nil then
  ret = ret2.status_code ~= nil and ret2 or nil
end
if ret ~= nil then
  response.code = ret.status_code
  response.message = ret.message
else
  response.code = 200
end
--#ENDPOINT GET /keystore
return to_json(Keystore.list())
--#ENDPOINT DELETE /keystore
response = Keystore.clear()
--#ENDPOINT GET /keystore/{key}
return to_json(Keystore.get({key=request.parameters.key}))
--#ENDPOINT PUT /keystore/{key}
obj = Keystore.get({key=request.parameters.key})
if next(obj) == nil then
  response.message = "add a new one"
else
  response.message = "key existed,update now"
end
ret = Keystore.set({key=request.parameters.key, value=request.body.value})
--#ENDPOINT DELETE /keystore/{key}
obj = Keystore.get({key=request.parameters.key})
if next(obj) == nil then
  response.message = "key is not existing"
else
  response.message = "key is existing,delete now"
  Keystore.delete({key=request.parameters.key})
end
Keystore.delete({key="aaa"})
--#ENDPOINT POST /email/{mailto}
local emailData = {
  to = request.parameters.mailto,
  subject = "Hello",
  text = request.body.msg,
}
response = Email.send(emailData)
