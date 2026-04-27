# Projekt: Digitálne stopky 
Tento projekt implementuje digitálne stopky na desku Nexys A7-50T v jazyku VHDL. Stopky merajú čas s presnosťou na stotiny sekundy a umožňujú zmerať čas jednotlivých kôl bez prerušenia merania na pozadí.

# Členovia týmu
- Tomáš Kovařík
- Maroš Kožár
- Áron Kristofori

# Blokové schema
![Blokové schema](./top_schematic.svg)

# Komponenta `ctrl_fsm` 
Tento modul má na starosti spracovávanie vstupov z tlačidiel a ovládanie stavu hodiniek. S prostredným tlačidlom `btnc` sa spúšťájú a zastavujú stopky. Tento proces sa ovláda pomocou výstupného signálu `sig_cnt_en` ktorý je privedený spolu s hodinovým signálom na vstup čítača. Tlačítká `btnd` a `btnu` nám dovolia prepínať medzi jednotlivými kolami uloženými v pamäti komponenty `lap_register`.

## Testovanie komponenty
![Screenshot z testbenchu](./res/tb_ctrl_fsm_wave.png)
Na začiatku behu testbenchu sme stav komponenty vynulovali pomocou `rst` signálu. Potom dvoma impulzmi na vstupe `start` sme výskúšali funkčnosť riadiaceho výstupu `cnt_en`. Ako ďaľšie bolo potrebné otestovať funkcionalitu `lap_ptr`. Výstupný signál si odoberá hodnotu z unsigned premennej v komponente ktorá sa inkrementuje/dekrementuje pomocou signálov na vstupoch `up`/`down`. Overili sme aj funkcionalitu pretečenia pri dosiahnutí krajných hodnôt 0 a 9.