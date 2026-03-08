# Используем официальный образ Rust для сборки
FROM rust:latest as builder

# Создаём рабочую директорию
WORKDIR /app

# Копируем исходники (мы их ещё добавим)
COPY . .

# Собираем приложение в релизном режиме
RUN cargo build --release

# Финальный образ
FROM debian:bookworm-slim

# Устанавливаем необходимые библиотеки
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Копируем собранный бинарник из предыдущего этапа
COPY --from=builder /app/target/release/antigravity-manager /usr/local/bin/antigravity-manager

# Указываем порт, который будет слушать приложение (Railway сам подставит нужный)
ENV PORT=8080

# Запускаем приложение
CMD ["antigravity-manager"]
