local Translations = {
    error = {
        no_people_nearby = "Keine Spieler in der Nähe",
        no_vehicle_found = "Kein Fahrzeug gefunden",
        extra_deactivated = "Extra %{extra} wurde deaktiviert",
        extra_not_present = "Extra %{extra} ist nicht an diesem Fahrzeug vorhanden",
        not_driver = "Du bist nicht der Fahrer des Fahrzeugs",
        vehicle_driving_fast = "Dieses Fahrzeug fährt zu schnell",
        seat_occupied = "Dieser Sitz ist besetzt",
        race_harness_on = "Du trägst bereits ein Rennharnisch, du kannst nicht wechseln",
        obj_not_found = "Das angeforderte Objekt konnte nicht erstellt werden",
        not_near_ambulance = "Du bist nicht in der Nähe eines Krankenwagens",
        far_away = "Du bist zu weit entfernt",
        stretcher_in_use = "Diese Trage wird bereits verwendet",
        not_kidnapped = "Du hast diese Person nicht entführt",
        trunk_closed = "Der Kofferraum ist geschlossen",
        cant_enter_trunk = "Du kannst nicht in diesen Kofferraum einsteigen",
        already_in_trunk = "Du bist bereits im Kofferraum",
        cancel_task = "Abgebrochen",
        someone_in_trunk = "Jemand ist bereits im Kofferraum"
    },
    progress = {
        flipping_car = "Fahrzeug wird umgedreht..."
    },
    success = {
        extra_activated = "Extra %{extra} wurde aktiviert",
        entered_trunk = "Du bist im Kofferraum"
    },
    info = {
        no_variants = "Es scheint keine Varianten dafür zu geben",
        wrong_ped = "Dieses Ped-Modell erlaubt diese Option nicht",
        nothing_to_remove = "Du scheinst nichts zum Entfernen zu haben",
        already_wearing = "Du trägst das bereits",
        switched_seats = "Du befindest dich jetzt auf dem %{seat}"
    },
    general = {
        command_description = "Öffne das Radialmenü",
        push_stretcher_button = "[E] - Trage schieben",
        stop_pushing_stretcher_button = "~g~E~w~ - Aufhören zu schieben",
        lay_stretcher_button = "[G] - Auf der Trage liegen",
        push_position_drawtext = "Hier schieben",
        get_off_stretcher_button = "[G] - Von der Trage steigen",
        get_out_trunk_button = "[E] Aus dem Kofferraum aussteigen",
        close_trunk_button = "[G] Kofferraum schließen",
        open_trunk_button = "[G] Kofferraum öffnen",
        getintrunk_command_desc = "In den Kofferraum steigen",
        putintrunk_command_desc = "Spieler in den Kofferraum legen",
        gang_radial = "Gang",
        job_radial = "Job"
    },
    options = {
        flip = 'Fahrzeug umdrehen',
        vehicle = 'Fahrzeug',
        emergency_button = "Notfallknopf",
        driver_seat = "Fahrersitz",
        passenger_seat = "Beifahrersitz",
        other_seats = "Andere Sitze",
        rear_left_seat = "Hinten links",
        rear_right_seat = "Hinten rechts"
    },
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
--translate by stepan_valic