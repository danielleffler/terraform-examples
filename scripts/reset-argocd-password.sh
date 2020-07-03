
# https://www.browserling.com/tools/bcrypt to generate a new hash

echo 'go to https://www.browserling.com/tools/bcrypt to generate a new hash'
read -p 'Enter Password:' pass

if [ -z "$pass" ]; then
   
    echo "Password cannot be empty"
    exit 1;
fi

kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": '\"$pass\"',
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'