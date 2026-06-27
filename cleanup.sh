echo "DANGER! Cleanup all volume env files? [y/n]: "
read -r raw_ans < /dev/tty
ans=$(echo "$raw_ans" | tr -d '\r')

case "$ans" in
    [Yy]) 
        echo "Stopping and removing container..."
        docker stop todoapp-env-postgres 2>/dev/null
        docker rm todoapp-env-postgres 2>/dev/null
        
        echo "Clearing data..."
        if [ -d "/app/out/pgdata" ]; then
            rm -rf /app/out/pgdata/*
        fi
        echo "Env files cleaned. Thanks for freedom!"
        ;;
    *) 
        echo "Env cleanup cancelled."
        ;;
esac
