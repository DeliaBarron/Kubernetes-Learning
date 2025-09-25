kubectl create secret generic strapi-k017712 \
--from-literal=MINIO_SECRET_KEY=Iequoh8Aezoovooyooquahng \
--from-literal=ADMIN_JWT_SECRET=Rohsh9vah2aocheekieKeigh \
--from-literal=USER_PASSWORD=7nPwSJNs9o \
--dry-run=client -o yaml | kubeseal --controller-namespace=sealed-secrets --namespace cloudwifi-cms -o=yaml > strapi-k017712.secret.sealed.yml



@ cloudwifi.prod

CREATE DATABASE "strapi-K017712";
ALTER DATABASE "strapi-K017712" OWNER TO "strapi";


push to a branch with the strapi name: add.....
