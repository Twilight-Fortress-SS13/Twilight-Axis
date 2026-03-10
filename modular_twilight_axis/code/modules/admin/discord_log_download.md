# Discord Log Download / Загрузка логов через Discord

## RU

### Что делает этот код

Этот модуль добавляет admin-only команду `logs` для TGS Discord/admin chat.

Команда позволяет:

1. Просматривать содержимое `data/logs` и текущей папки раунда.
2. Переходить по подпапкам через нумерованный список.
3. Запрашивать конкретный лог по номеру или по относительному пути.
4. Отправлять лог напрямую в Discord как файл через webhook.
5. Если webhook не настроен или загрузка не удалась, отдавать временную ссылку на просмотр и скачивание файла через веб-сервер игры.

### Как это работает

Основные подкоманды:

- `logs`
- `logs current`
- `logs current <file>`
- `logs list <relative_dir>`
- `logs browse <number>`
- `logs get <number>`
- `logs path <relative_file>`

Поведение:

1. `logs` без аргументов показывает текущую папку логов раунда, если она уже существует. Иначе показывает корень `data/logs`.
2. `logs list <dir>` показывает содержимое указанной папки внутри `data/logs`.
3. `logs browse <number>` открывает подпапку из последнего списка.
4. `logs get <number>` запрашивает файл из последнего списка.
5. `logs current <file>` сразу берет файл из текущей папки логов раунда.
6. `logs path <file>` сразу берет файл по относительному пути внутри `data/logs`.

Ограничения и TTL:

- За один вывод показывается максимум `15` записей.
- Выбор по номерам (`browse/get`) живет `15 минут`.
- Временная ссылка на файл живет `10 минут`.

### Что нужно для работы

Обязательная база:

1. У вас уже настроен TGS chat bridge с Discord.
2. Команда `logs` должна быть доступна через TGS admin chat.
3. Пользователь, запускающий команду, должен иметь доступ к admin-only командам TGS.
4. Сервер должен иметь доступ к папке `data/logs`.

### Рекомендуемая настройка: отправка файла прямо в Discord

Это основной и наиболее удобный режим.

Что сделать:

1. Создайте закрытый Discord-канал для логов или используйте приватный админский канал.
2. Создайте в этом канале `Incoming Webhook`.
3. Добавьте в конфиг сервера:

`ADMIN_LOGS_WEBHOOK_URL https://discord.com/api/webhooks/...`

4. Перезапустите сервер.

После этого команды, которые возвращают файл (`logs get`, `logs path`, `logs current <file>`), будут пытаться загрузить лог в Discord как вложение.

Предпочтительно указывать полный `https://...` URL. Код также умеет нормализовать частые варианты без схемы, например `discord.com/api/webhooks/...` или `/api/webhooks/...`, но полный URL надежнее и понятнее.

Что реально отправляется через webhook:

- Текстовое сообщение с указанием, кто запросил лог.
- Сам файл лога как `text/plain`.

### Резервный режим: временная ссылка

Если `ADMIN_LOGS_WEBHOOK_URL` не задан или Discord отклонил upload, модуль автоматически переключается на fallback и возвращает временную ссылку.

Ссылка открывает HTML-страницу, где:

- показывается содержимое лога;
- есть кнопка `Download log`;
- файл можно скачать из браузера.

### Как настроить fallback-ссылки

Для внешнего доступа желательно явно задать адрес сервера:

`SERVER http://your-host:port/`

Что важно:

1. Если `SERVER` задан, модуль использует его как базовый URL для временных ссылок.
2. Если `SERVER` не задан, модуль пытается собрать адрес из `world.internet_address`, затем из `world.address`, и добавляет `world.port`.
3. Если сервер недоступен снаружи, временная ссылка будет работать только там, откуда этот адрес реально достижим.

### Безопасность

В коде уже есть базовая защита:

- команда доступна только как `admin_only`;
- пути нормализуются;
- нельзя выйти за пределы `data/logs`;
- запрещены `..`, абсолютные пути, `:` и переводы строки в пути;
- просроченные токены и кэш выбора очищаются автоматически.

Рекомендуется дополнительно:

1. Использовать webhook только в закрытом канале.
2. Не коммитить `ADMIN_LOGS_WEBHOOK_URL` в репозиторий.
3. Не полагаться на временные ссылки как на основной способ выдачи логов, если сервер торчит в публичную сеть.
4. Ограничить доступ к каналу с логами только администраторам.

### Быстрая проверка после настройки

1. Выполните `logs`.
2. Выполните `logs current`.
3. Выполните `logs list <нужная_папка>`.
4. Выполните `logs get <номер_файла>`.
5. Убедитесь, что файл либо пришел в Discord, либо вернулась рабочая временная ссылка.

### Примеры команд

- `logs`
- `logs current`
- `logs current game.log`
- `logs list 2026/03/10`
- `logs browse 2`
- `logs get 1`
- `logs path 2026/03/10/round-123/runtime.log`

## EN

### What this code does

This module adds an admin-only `logs` command for the TGS Discord/admin chat integration.

It allows admins to:

1. Browse `data/logs` and the current round log directory.
2. Navigate subdirectories through a numbered list.
3. Request a specific log by list number or by relative path.
4. Upload the selected log directly to Discord through a webhook.
5. Fall back to a temporary web link if the webhook is not configured or the upload fails.

### How it works

Main subcommands:

- `logs`
- `logs current`
- `logs current <file>`
- `logs list <relative_dir>`
- `logs browse <number>`
- `logs get <number>`
- `logs path <relative_file>`

Behavior:

1. `logs` with no arguments shows the current round log directory if it already exists. Otherwise it shows the `data/logs` root.
2. `logs list <dir>` shows the selected directory inside `data/logs`.
3. `logs browse <number>` opens a subdirectory from the last list.
4. `logs get <number>` requests a file from the last list.
5. `logs current <file>` requests a file from the current round log directory.
6. `logs path <file>` requests a file by relative path inside `data/logs`.

Limits and TTLs:

- A single listing shows up to `15` entries.
- Numbered selections for `browse/get` remain valid for `15 minutes`.
- Temporary log links remain valid for `10 minutes`.

### Requirements

Required baseline setup:

1. TGS Discord chat bridge is already configured.
2. The `logs` command is available through TGS admin chat.
3. The user running the command has access to TGS admin-only commands.
4. The server can read from the `data/logs` directory.

### Recommended setup: upload the file directly to Discord

This is the primary and most convenient mode.

Steps:

1. Create a private Discord log channel, or reuse a private admin-only channel.
2. Create an `Incoming Webhook` in that channel.
3. Add this to the server config:

`ADMIN_LOGS_WEBHOOK_URL https://discord.com/api/webhooks/...`

4. Restart the server.

After that, file-returning commands such as `logs get`, `logs path`, and `logs current <file>` will try to upload the selected log directly to Discord as an attachment.

Use a full `https://...` URL whenever possible. The code also normalizes common scheme-less inputs such as `discord.com/api/webhooks/...` or `/api/webhooks/...`, but the full URL is the preferred format.

What the webhook sends:

- A text message showing who requested the log.
- The log file itself as `text/plain`.

### Fallback mode: temporary link

If `ADMIN_LOGS_WEBHOOK_URL` is missing, or Discord rejects the upload, the module automatically falls back to a temporary link.

The link opens an HTML page that:

- renders the log contents;
- provides a `Download log` button;
- allows the file to be downloaded in a browser.

### How to configure fallback links

For external access, it is best to set the server address explicitly:

`SERVER http://your-host:port/`

Important details:

1. If `SERVER` is set, the module uses it as the base URL for temporary links.
2. If `SERVER` is not set, the module tries `world.internet_address`, then `world.address`, and appends `world.port`.
3. If the game server is not externally reachable, the temporary link only works from places that can reach that address.

### Security

The code already includes baseline protections:

- the command is `admin_only`;
- paths are normalized;
- access is restricted to `data/logs`;
- `..`, absolute paths, `:`, and newline characters are rejected in paths;
- expired tokens and cached selections are cleaned up automatically.

Additional recommendations:

1. Use the webhook only in a private channel.
2. Do not commit `ADMIN_LOGS_WEBHOOK_URL` into the repository.
3. Do not rely on temporary links as the primary delivery method if the server is publicly reachable.
4. Restrict the log channel to administrators only.

### Quick verification after setup

1. Run `logs`.
2. Run `logs current`.
3. Run `logs list <target_dir>`.
4. Run `logs get <file_number>`.
5. Confirm that the file is either uploaded to Discord or returned as a working temporary link.

### Command examples

- `logs`
- `logs current`
- `logs current game.log`
- `logs list 2026/03/10`
- `logs browse 2`
- `logs get 1`
- `logs path 2026/03/10/round-123/runtime.log`
