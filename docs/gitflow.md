# каждую задачу надо делать в новой ветке ответвляясь каждый раз от development? а когда надо делать мёрж в девелопмент-ветку или пулл-реквест?

В типичном git-воркфлоу для разработки игры (в том числе на Defold) чаще всего используют центральную ветку **development** (или `develop`), от которой все новые функции (фичи) разрабатываются в отдельных ветках, чтобы сохранять стабильность основной ветки разработки.

Вот основные рекомендации для вашего вопроса:

### Ветки для задач (feature branches)

- **Да**, каждую задачу (фичу) стоит делать в новой отдельной ветке, которая создаётся **от ветки `development`**.
Например:

```bash
git checkout development
git pull origin development  
git checkout -b feature/shop-placeholder
```

- Это позволяет изолировать задачи, избежать конфликтов и сохранять `development` стабильной.


### Мёрж и пулл-реквесты (Pull Requests, PR)

- Когда задача полностью готова, протестирована локально и закоммичена в своей ветке, происходит **слияние этой feature-ветки обратно в `development`**.
- Перед мёржем желательно создавать **Pull Request** (PR) на GitHub/GitLab/Bitbucket и делать Code Review, особенно если в команде несколько человек.
- PR помогает проверить, что изменения корректны, нет конфликтов, и в `development` не попадут «сырые» или сломанные фичи.


### Когда делать merge в development?

- Когда задача полностью закончена (фича реализована, протестирована, документирована).
- В идеале — мёржи делать небольшими порциями, не ждать пока много задач накопится, чтобы избежать тяжёлых конфликтов.
- Если задача разбивается на части, то каждую часть можно делать отдельной веткой, мерджить по завершению этой части, либо делать её sub-branch от основной feature-ветки. Это зависит от размера и сложности задачи.


### Итоговый рекомендуемый workflow для ваших задач:

| Шаг | Команда Git | Комментарий |
| :-- | :-- | :-- |
| 1. Обновить ветку development | `git checkout development` <br> `git pull origin development` | Забираем актуальный код перед созданием новой ветки |
| 2. Создать feature ветку с описанием задачи | `git checkout -b feature/<описание_задачи>` | Пример: `feature/shop-input` |
| 3. Делать маленькие коммиты по задаче | `git add .` <br> `git commit -m "feat: добавить обработку клика"` | Делать осмысленные коммиты регулярно |
| 4. Отправить ветку в репозиторий (remote) | `git push origin feature/<описание_задачи>` | Чтобы иметь резерв и PR |
| 5. Создать Pull Request и провести ревью | Через GitHub/GitLab интерфейс | Обсудить изменения, исправить замечания |
| 6. Мёржить feature ветку в development после одобрения | Через интерфейс или через git merge | После успешного тестирования |
| 7. Удалять локальную и удалённую feature ветку, если не нужна | `git branch -d feature/<название>` <br> `git push origin --delete feature/<название>` | Для чистоты репозитория |

### Важные советы для Defold проектов:

- В Defold встроенный git клиент ограничен — лучше для работы с ветками использовать отдельный Git-клиент (GitHub Desktop, Sourcetree, Git CLI).
- Всегда перед созданием feature-ветки синхронизируйте local `development` с remote.
- Часто обновляйте вашу feature-ветку из `development` (через rebase или merge), чтобы избежать многократных конфликтов при финальном мёрже.
- Старайтесь делать небольшие, изолированные задачи, чтобы PR были легче для ревью и тестирования.

Если хотите, могу помочь с написанием примеров команд или PR описаний для вашего репозитория под Defold.

**Краткий ответ:**
Для каждой задачи создавайте новую ветку от `development`. После завершения задачи и тестирования делайте Pull Request и мёржите в `development`. Это позволяет командно и безопасно управлять кодом в Defold проекте.

---

## Links

- [source prompt](https://www.perplexity.ai/search/konechnaia-tsel-sozdan-mvp-igr-NG7nbtNzRaGQbuBVFOs.9Q)

<div style="text-align: center">⁂</div>

[^1]: https://playgama.com/blog/general/mastering-git-and-github-for-effective-game-development-projects/

[^2]: https://www.reddit.com/r/gamedev/comments/1k83bn/git_workflow_guide/

[^3]: https://playgama.com/blog/unity/what-is-the-process-for-managing-and-deleting-branches-in-version-control-for-a-game-development-project-using-git/

[^4]: https://www.reddit.com/r/git/comments/18ilruf/should_i_made_a_develop_branch_along_with_feature/

[^5]: https://forum.defold.com/t/git-workflow-in-defold/1385

[^6]: https://defold.com/manuals/libraries/

[^7]: https://github.com/defold/defold/blob/dev/CONTRIBUTING.md

[^8]: https://forum.defold.com/t/big-list-of-defold-pro-tips/1519

[^9]: https://github.com/astrochili/awesome-defold

[^10]: https://defold.com/ru/manuals/extensions-best-practices/

