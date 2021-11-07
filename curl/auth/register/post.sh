curl -X POST http://localhost:3000/auth/register \
  -F "name=Alexey" \
  -F "surname=Gmitron" \
  -F "avatar_uri=1.png" \
  -F "login=agmitron" \
  -F "password=1231231123" \
  -F "is_admin=true" \
  -H "Content-Type: multipart/form-data"
