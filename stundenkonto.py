import sqlite3

def update_stundenkonto_monat(db_path="log_arbeit.db", jahr=2025, monat=6):
    conn = sqlite3.connect(db_path)
    c = conn.cursor()

    c.execute(f"""
    SELECT m.id, 
           COALESCE(SUM(((julianday(a.endzeit) - julianday(a.startzeit)) * 24 * 60 - a.pause_minuten) / 60.0), 0) AS geleistete_stunden,
           t.arbeitszeitanteil * 39.0 AS sollstunden
    FROM mitarbeiter m
    LEFT JOIN arbeitszeit a ON m.id = a.mitarbeiter_id AND a.startzeit >= '{jahr}-{monat:02d}-01' AND a.startzeit < '{jahr}-{monat+1:02d}-01'
    LEFT JOIN tarifvertrag t ON m.tarifvertrag_id = t.id
    GROUP BY m.id, sollstunden
    """)

    daten = c.fetchall()

    for mitarbeiter_id, geleistete, soll in daten:
        saldo = geleistete - soll
        c.execute("""
        INSERT INTO stundenkonto_monat (mitarbeiter_id, jahr, monat, geleistete_stunden, sollstunden, saldo)
        VALUES (?, ?, ?, ?, ?, ?)
        ON CONFLICT(mitarbeiter_id, jahr, monat) DO UPDATE SET
            geleistete_stunden=excluded.geleistete_stunden,
            sollstunden=excluded.sollstunden,
            saldo=excluded.saldo
        """, (mitarbeiter_id, jahr, monat, geleistete, soll, saldo))

    conn.commit()
    conn.close()

if __name__ == "__main__":
    update_stundenkonto_monat()
