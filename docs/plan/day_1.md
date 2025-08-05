# День 1: Подробный порядок выполнения задач для Defold 1.10.4a

## 1. Создать проект Defold, настроить сборку

**Тип:** простая
**Ветка:** init-project
**Git-flow:**

- `git checkout -b init-project`
**Подробно:**
- Открыть Defold, создать новый проект через `File → New Project`.
- Указать каталог, имя проекта, выбрать пустой шаблон.
- Настроить базовые папки (main, assets, scripts, gui).
- Инициализировать git-репозиторий:

```bash
git init
git add .
git commit -m "init: базовая структура проекта"
```

- Проверить сборку: запустить проект на ПК (`Project → Build`).
- Сохранить результат.

> _Комментарий:_
> Начальный commit должен включать только структуру проекта и дефолтные файлы Defold.

## 2. Создать базовый main.collection с двумя экранами (Shop и Game)

**Тип:** простая
**Ветка:** screen-scaffolding
**Git-flow:**

- `git checkout -b screen-scaffolding`
- После выполнения — коммит:
`git commit -am "feat: добавлен каркас main.collection с Shop и Game"`

**Подробно:**

- Открыть main.collection.
- Добавить два Game Object: `shop_screen` и `game_screen`.
- Для каждого — создать и добавить пустые коллекции (shop.collection, game.collection).
- Связать их через collection proxy, чтобы реализовать динамическую смену экранов.
- Оставить активным только один экран при запуске (например, Shop).
- Реализовать заглушку скриптов для переключения сцен (будет расширено позже):

**Мини-скрипт** (shop_screen.script):

```lua
function on_input(self, action_id, action)
    if action_id == hash("switch_to_game") and action.pressed then
        msg.post("main:/shop_screen#proxy", "disable")
        msg.post("main:/game_screen#proxy", "enable")
    end
end
```

> _Комментарий:_
> В Defold основной способ перехода между экранами — collection proxy. Можно оставить переходы пустыми, реализовать переходы в дальнейшем.

## 3. Добавить placeholder-спрайт монстра в Shop

**Тип:** простая
**Ветка:** shop-monster-placeholder
**Git-flow:**

- `git checkout -b shop-monster-placeholder`
- Коммит после загрузки спрайта:
`git commit -am "feat: placeholder-спрайт для Shop"`

**Шаги:**

- Создать в `assets` папку `sprites`, добавить изображение-заглушку монстра (`monster_placeholder.png`).
- Создать atlas (`monsters.atlas`), добавить туда картинку.
- В сцене Shop добавить Game Object `monster_placeholder`, компонент Sprite со спрайтом из atlas.
- Позиционировать спрайт в центре shop_screen.
- Проверить отображение в Build.


## 4. Настроить input для кликов по shop-монстру

**Тип:** средняя
**Ветка:** shop-input
**Git-flow:**

- `git checkout -b shop-input`
- Коммит после реализации базового input:
`git commit -am "feat: обработка клика по Shop-монстру"`

**Шаги:**

- Для `monster_placeholder.go` добавить скрипт обработки input.
- В скрипте:
    - В функции `on_input(self, action_id, action)` проверять попадание курсора мыши на область спрайта.
    - При клике — выводить print("Монстр куплен").

**Пример кода:**

```lua
function on_input(self, action_id, action)
    if action_id == hash("touch") and action.pressed then
        local x, y = action.x, action.y
        if is_point_in_monster_area(x, y, self.position) then
            print("Монстр куплен")
        end
    end
end

function is_point_in_monster_area(x, y, monster_pos)
    -- Псевдокод — сделать через bounds спрайта
    return (math.abs(x - monster_pos.x) < 64 and math.abs(y - monster_pos.y) < 64)
end
```

> _Комментарий:_
> Defold не имеет стандартного hitbox для спрайта — обычно считаем bounds вручную.

## 5. Сделать базовый game_manager (lua module) для хранения монет и состояния

**Тип:** средняя
**Ветка:** game-manager
**Git-flow:**

- `git checkout -b game-manager`
- Коммит:
`git commit -am "feat: базовый game_manager с монетами и состоянием"`

**Детали:**

- Создать скрипт-модуль `game_manager.lua`:

```lua
local M = {
    coins = 0,
    monsters = {}
}
function M.add_coins(n)
    M.coins = M.coins + n
end

function M.buy_monster(monster_id)
    table.insert(M.monsters, monster_id)
end

return M
```

- Добавить require("main/game_manager") в shop и другие скрипты.
- Проверить работу:
    - shop input: по клику M.add_coins(1).
    - Выводить print на количество монет.

> _Комментарий:_
> Все глобальное состояние, не относящееся к GUI — через отдельный модуль.

## 6. Интегрировать систему состояний (lua msg.post/state machines) для экранов

**Тип:** сложная
**Ветка:** state-management
**Git-flow:**

- `git checkout -b state-management`
- Коммит:
`git commit -am "feat: система состояний для переключения экранов"`

**Подробный Plan:**

- Создать луа-модуль state_manager.lua:

```lua
local M = { state = "shop" }
function M.switch_to(state)
    msg.post("main:/shop_screen#proxy", state == "shop" and "enable" or "disable")
    msg.post("main:/game_screen#proxy", state == "game" and "enable" or "disable")
    M.state = state
end
return M
```

- Подключить к shop_screen.script простой вызов:

```lua
local state_manager = require("main/state_manager")
-- При событии (клик по кнопке "Game")
state_manager.switch_to("game")
```

- Проверить:
    - Переход из Shop в Game сменой состояния (enable/disable proxy).
    - Состояния корректно переключаются без ошибок.

> _Комментарий:_
> Управлять сценами в Defold предпочтительнее через proxy, чтобы не грузить все экраны одновременно.

## Рекомендации по коммитам и веткам:

- Каждую задачу выполнять отдельным git-branch, не объединяя задачи одного дня до конца дня (чтобы можно было делать ревью по шагам).
- Каждый шаг фиксировать: сначала структуру, потом код, потом интеграцию/связку.

**Для каждой из задач:**

- Делайте комментарии в коде, чтобы следующий разработчик понимал, зачем этот код.
- Для любой реализации используйте только дефолтные возможности Defold и Lua 5.1.

> Если нужно примеры файлов, схемы, или описание структуры репозитория — уточните, добавлю.
