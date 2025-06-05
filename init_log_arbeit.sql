CREATE TABLE mitarbeiter (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
tarifvertrag_id INTEGER,
FOREIGN KEY (tarifvertrag_id) REFERENCES tarifvertrag(id)
)

CREATE TABLE tarifvertrag (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL, 
arbeitszeitanteil REAL NUT NULL,
urlaubsanspruch REAL NOT NULL
)

CREATE TABLE arbeitszeit (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mitarbeiter_id INTEGER NOT NULL,
    startzeit DATETIME NOT NULL,
    endzeit DATETIME NOT NULL,
    pause_minuten INTEGER DEFAULT 30,
    bemerkung TEXT,
    FOREIGN KEY (mitarbeiter_id) REFERENCES mitarbeiter(id)
)

CREATE TABLE stundenkonto_monat (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mitarbeiter_id INTEGER NOT NULL,
    jahr INTEGER NOT NULL,
    monat INTEGER NOT NULL,
    geleistete_stunden REAL NOT NULL DEFAULT 0,
    sollstunden REAL NOT NULL DEFAULT 0,
    saldo REAL NOT NULL DEFAULT 0,  -- geleistete - sollstunden
    FOREIGN KEY (mitarbeiter_id) REFERENCES mitarbeiter(id),
    UNIQUE(mitarbeiter_id, jahr, monat)  -- verhindert doppelte Einträge für denselben Monat
)