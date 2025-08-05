# День 2: Подробный порядок выполнения задач для Defold 1.10.4a

## 1. Добавить визуализацию области shop

**Тип:** простая
**Ветка:** shop-area-draw
**Git-flow:**

- `git checkout development && git pull`
- `git checkout -b shop-area-draw`

**Шаги:**

- Открыть `shop.collection` в Defold.
- В магазине создать отдельный Game Object `shop_area_go`.
- К `shop_area_go` добавить GUI компонент или Sprite-компонент (например, с простым квадратным или рамочным смещением).
- Нарисовать прямоугольник рамкой или полупрозрачным спрайтом (можно временно использовать текстуру в 1 цвет).
- Изменить позицию объекта, чтобы визуально выделить зону Shop в интерфейсе.
- **Коммит:**
`git add .`
`git commit -m "feat: визуализирована область магазина (shop area)"`


## 2. Реализовать подсчёт монет по кликам

**Тип:** простая
**Ветка:** click-to-earn
**Git-flow:**

- `git checkout development && git pull`
- `git checkout -b click-to-earn`
- (Если используете прошлую ветку shop-input — сделать rebase или merge, если не успели слить туда реализацию)

**Шаги:**

- В скрипте shop-монстра (например, `shop_monster.script`) добавить требуемый импорт:

```lua
local game_manager = require "main.game_manager"
```

- В `on_input` обработчике при клике на монстра:

```lua
if is_point_in_monster_area(action.x, action.y, go.get_position()) then
    game_manager.add_coins(1)
    print("Монеты: " .. game_manager.coins)
end
```

- **Коммит:**
`git add .`
`git commit -m "feat: начисление монет по клику на shop-монстра"`


## 3. При покупке монстра создавать экземпляры спрайтов во 2-м экране

**Тип:** простая
**Ветка:** spawn-monster
**Git-flow:**

- `git checkout development && git pull`
- `git checkout -b spawn-monster`

**Шаги:**

- Создать `monster_factory.go` с компонентом `factory` (ссылается на monster.prefab).
- В сцене game_screen разместить factory.
- В скрипте сделки (shop_monster.script или отдельном controller):

```lua
if game_manager.coins >= monster_cost then
    game_manager.buy_monster(monster_id)
    -- msg.post("main:/monster_factory#factory", "create", { ... })
end
```

- Передавать позицию для создания монстра (будет дорабатываться).
- **Коммит:**
`git add .`
`git commit -m "feat: спавн монстра через factory при покупке"`


## 4. Реализовать рандомное размещение спрайтов в игровой области

**Тип:** средняя
**Ветка:** random-position
**Git-flow:**

- `git checkout development && git pull`
- `git checkout -b random-position`

**Шаги:**

- Написать функцию генерации позиции:

```lua
function get_random_position(area)
    local x = area.x + math.random() * area.width
    local y = area.y + math.random() * area.height
    return vmath.vector3(x, y, 0)
end
```

- При покупке монстра, перед созданием через factory, вычислять позицию за пределами коллизий shop.
- area — заранее объявленные размеры области во 2-м экране.
- **Коммит:**
`git add .`
`git commit -m "feat: случайное размещение спрайтов новых монстров"`


## 5. Создать простой UI для отображения текущих монет

**Тип:** средняя
**Ветка:** coins-ui
**Git-flow:**

- `git checkout development && git pull`
- `git checkout -b coins-ui`

**Шаги:**

- Создать отдельную .gui сцену `coins.gui` с текстовым node "COINS: 0".
- Привязать gui-script:

```lua
local game_manager = require "main.game_manager"
function update(self, dt)
    gui.set_text(gui.get_node("coins"), "COINS: " .. game_manager.coins)
end
```

- Поместить GUI node в верхний угол интерфейса.
- Добавить gui к общей shop.collection.
- **Коммит:**
`git add .`
`git commit -m "feat: отображение количества монет в UI"`


## 6. Разработать персистентное хранение состояния (сохранение в файл)

**Тип:** сложная
**Ветка:** save-load
**Git-flow:**

- `git checkout development && git pull`
- `git checkout -b save-load`

**Шаги:**

- В game_manager.lua добавить функции сохранения и загрузки:

```lua
-- Сохранение
function M.save()
    sys.save(sys.get_save_file("my_clicker", "save"), { coins = M.coins, monsters = M.monsters })
end
-- Загрузка
function M.load()
    local data = sys.load(sys.get_save_file("my_clicker", "save"))
    M.coins = data.coins or 0
    M.monsters = data.monsters or {}
end
```

- В `init()` game_manager вызвать M.load(), а после покупки монстра — M.save().
- Проверить, что после перезапуска игры монеты и купленные монстры загружаются.
- **Коммит:**
`git add .`
`git commit -m "feat: сохранение и загрузка состояния (монеты, монстры)"`


## Пример git-flow для всех задач 2 дня

(для каждой задачи новый feature-branch от `development`; после тестирования feature — Pull Request → merge → удаление ветки; повторить для следующей задачи.)

## Общие моменты

- После завершения каждой задачи отправляйте изменения на сервер (push to remote branch).
- После merge feature-ветки в development — обязательно делайте pull перед началом следующей ветки.
- Бета-тестировать новую функциональность на каждом этапе отдельно, убедившись, что старый и новый код не конфликтуют.
- В Defold важно хранить .collection, .script, .lua файлы и ресурсы под контролем версий, не забывайте добавлять их в коммиты.

> **Если потребуется примеры файлов, содержания atlas/factory, базовые заготовки — сообщите, пришлю шаблоны!**

---

## Links

- [source prompt 1](https://www.perplexity.ai/search/konechnaia-tsel-sozdan-mvp-igr-NG7nbtNzRaGQbuBVFOs.9Q)
