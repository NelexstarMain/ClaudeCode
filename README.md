# Claude Code — System Higieny Pracy (`~/.claude/`)

Gotowy, spersonalizowany szablon dla **Linux VM** oparty o czysty **Python 3 (stdlib, zero zależności zewnętrznych)** oraz mechanizmy `code.claude.com/docs/`.

## Instalacja w maszynie wirtualnej (Linux)

```bash
git clone https://github.com/NelexstarMain/ClaudeCode.git
cd ClaudeCode
chmod +x install.sh
./install.sh
```

Skrypt najpierw uruchamia wszystkie testy jednostkowe (`tests/test_hooks.py`), tworzy kopię zapasową istniejących plików (`~/.claude/backups/...`), kopiuje konfigurację do `~/.claude/` i nadaje prawa wykonywalności skryptom hooków.

## Użycie na co dzień

1. **Nowy projekt lub duże zadanie:** wpisz `/core-kickoff` — przeprowadzi adaptacyjny wywiad po polsku, wykona lekki rekonesans subagentem, wygeneruje zwięzły `./CLAUDE.md` (z sekcją `<!-- HYGIENE:AUTO -->`) po angielsku oraz sprawdzi środowisko testowe.
2. **Praca w rytmie TDD:** hook `Stop` pilnuje weryfikacji testami po zmianach w kodzie produkcyjnym (ignoruje `*.md`, `.claude/**`, `docs/**`), a jednocześnie przepuszcza świadomą fazę Red (gdy test został uruchomiony po ostatniej edycji).
3. **Kontrola kontekstu (30% / 50%):**
   - od **30%** pasek `statusLine` zmienia kolor na żółty,
   - od **50%** pojawia się czerwony alert oraz `systemMessage` na końcu tury,
   - wpisujesz `/core-wrapup` (zapisuje gęsty `.claude/handoff.md` ~1500 tokenów), a następnie `/clear` — `SessionStart` automatycznie wstrzyknie `handoff.md` do nowej sesji i zarchiwizuje go do `.claude/handoff.consumed.md`.
4. **Automaty w tle (Haiku `Restricted Edit`):**
   - co **40 min** skumulowanej pracy w projekcie Haiku porządkuje sekcję `<!-- HYGIENE:AUTO -->` w `CLAUDE.md` i dopisuje obserwacje do `.claude/hygiene-report.md` (zero `Bash`, zero `Write`, tryb `dontAsk`, limit `$0.20`, pełny rollback przy naruszeniu granic),
   - co **10 h** łącznej pracy konsoliduje globalny `~/.claude/preferences.md` (twardy limit **70 linii**).

## Testowanie

```bash
python3 -m unittest discover -s tests -v
```
