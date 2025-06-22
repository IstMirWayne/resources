local Translations = {
    error = {
        not_online                  = 'Spieler nicht online',
        wrong_format                = 'Falsches Format',
        missing_args                = 'Nicht alle Argumente wurden eingegeben (x, y, z)',
        missing_args2               = 'Alle Argumente müssen ausgefüllt sein!',
        no_access                   = 'Kein Zugriff auf diesen Befehl',
        company_too_poor            = 'Dein Arbeitgeber ist pleite',
        item_not_exist              = 'Gegenstand existiert nicht',
        too_heavy                   = 'Inventar zu voll',
        location_not_exist          = 'Ort existiert nicht',
        duplicate_license           = '[QBCORE] - Doppelte Rockstar-Lizenz gefunden',
        no_valid_license            = '[QBCORE] - Keine gültige Rockstar-Lizenz gefunden',
        not_whitelisted             = '[QBCORE] - Du bist nicht auf der Whitelist für diesen Server',
        server_already_open         = 'Der Server ist bereits geöffnet',
        server_already_closed       = 'Der Server ist bereits geschlossen',
        no_permission               = 'Du hast keine Berechtigung dafür..',
        no_waypoint                 = 'Kein Wegpunkt gesetzt.',
        tp_error                    = 'Fehler beim Teleportieren.',
        ban_table_not_found         = '[QBCORE] - Ban-Tabelle in der Datenbank nicht gefunden. Bitte stelle sicher, dass du die SQL-Datei korrekt importiert hast.',
        connecting_database_error   = '[QBCORE] - Fehler beim Verbinden mit der Datenbank. Stelle sicher, dass der SQL-Server läuft und die Angaben in der server.cfg korrekt sind.',
        connecting_database_timeout = '[QBCORE] - Die Verbindung zur Datenbank ist abgelaufen. Stelle sicher, dass der SQL-Server läuft und die Angaben in der server.cfg korrekt sind.',
    },
    success = {
        server_opened = 'Der Server wurde geöffnet',
        server_closed = 'Der Server wurde geschlossen',
        teleported_waypoint = 'Zum Wegpunkt teleportiert.',
    },
    info = {
        received_paycheck = 'Du hast deinen Gehaltsscheck in Höhe von $%{value} erhalten',
        job_info = 'Job: %{value} | Rang: %{value2} | Dienst: %{value3}',
        gang_info = 'Gang: %{value} | Rang: %{value2}',
        on_duty = 'Du bist jetzt im Dienst!',
        off_duty = 'Du bist jetzt außer Dienst!',
        checking_ban = 'Hallo %s. Wir prüfen, ob du gebannt bist.',
        join_server = 'Willkommen %s auf {Server Name}.',
        checking_whitelisted = 'Hallo %s. Wir prüfen deine Berechtigung.',
        exploit_banned = 'Du wurdest wegen Cheating gebannt. Schau auf unserem Discord für mehr Infos: %{discord}',
        exploit_dropped = 'Du wurdest wegen Ausnutzung gekickt',
    },
    command = {
        tp = {
            help = 'Teleport zu Spieler oder Koordinaten (Nur Admin)',
            params = {
                x = { name = 'id/x', help = 'ID des Spielers oder X-Position' },
                y = { name = 'y', help = 'Y-Position' },
                z = { name = 'z', help = 'Z-Position' },
            },
        },
        tpm = { help = 'Teleport zum Marker (Nur Admin)' },
        togglepvp = { help = 'PVP auf dem Server umschalten (Nur Admin)' },
        addpermission = {
            help = 'Spielerberechtigungen geben (Nur Gott)',
            params = {
                id = { name = 'id', help = 'Spieler-ID' },
                permission = { name = 'permission', help = 'Berechtigungsstufe' },
            },
        },
        removepermission = {
            help = 'Spielerberechtigungen entfernen (Nur Gott)',
            params = {
                id = { name = 'id', help = 'Spieler-ID' },
                permission = { name = 'permission', help = 'Berechtigungsstufe' },
            },
        },
        openserver = { help = 'Server für alle öffnen (Nur Admin)' },
        closeserver = {
            help = 'Server für Spieler ohne Berechtigung schließen (Nur Admin)',
            params = {
                reason = { name = 'reason', help = 'Grund für das Schließen (optional)' },
            },
        },
        car = {
            help = 'Fahrzeug spawnen (Nur Admin)',
            params = {
                model = { name = 'model', help = 'Modellname des Fahrzeugs' },
            },
        },
        dv = { help = 'Fahrzeug löschen (Nur Admin)' },
        dvall = { help = 'Alle Fahrzeuge löschen (Nur Admin)' },
        dvp = { help = 'Alle Peds löschen (Nur Admin)' },
        dvo = { help = 'Alle Objekte löschen (Nur Admin)' },
        givemoney = {
            help = 'Geld an Spieler geben (Nur Admin)',
            params = {
                id = { name = 'id', help = 'Spieler-ID' },
                moneytype = { name = 'moneytype', help = 'Geldart (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'Geldbetrag' },
            },
        },
        setmoney = {
            help = 'Geldbetrag eines Spielers setzen (Nur Admin)',
            params = {
                id = { name = 'id', help = 'Spieler-ID' },
                moneytype = { name = 'moneytype', help = 'Geldart (cash, bank, crypto)' },
                amount = { name = 'amount', help = 'Geldbetrag' },
            },
        },
        job = { help = 'Deinen Job anzeigen' },
        setjob = {
            help = 'Job eines Spielers setzen (Nur Admin)',
            params = {
                id = { name = 'id', help = 'Spieler-ID' },
                job = { name = 'job', help = 'Jobname' },
                grade = { name = 'grade', help = 'Jobrang' },
            },
        },
        gang = { help = 'Deine Gang anzeigen' },
        setgang = {
            help = 'Gang eines Spielers setzen (Nur Admin)',
            params = {
                id = { name = 'id', help = 'Spieler-ID' },
                gang = { name = 'gang', help = 'Gangname' },
                grade = { name = 'grade', help = 'Gangrang' },
            },
        },
        ooc = { help = 'OOC-Chatnachricht' },
        me = {
            help = 'Lokale Nachricht anzeigen',
            params = {
                message = { name = 'message', help = 'Nachricht zum Senden' }
            },
        },
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})