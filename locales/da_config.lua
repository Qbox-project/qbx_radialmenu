Config = {}

Config.EnableExtraMenu = true
Config.Fliptime = 15000

Config.MenuItems = {
    [1] = {
        id = 'citizen',
        title = 'Borger',
        icon = 'user',
        items = {
            {
                id = 'givenum',
                title = 'Del kontaktinfo',
                icon = 'address-book',
                type = 'client',
                event = 'qb-phone:client:GiveContactDetails',
                shouldClose = true
            }, {
                id = 'getintrunk',
                title = 'Hop i bagagerum',
                icon = 'car',
                type = 'client',
                event = 'qb-trunk:client:GetIn',
                shouldClose = true
            }, {
                id = 'cornerselling',
                title = 'Markedsplads',
                icon = 'cannabis',
                type = 'client',
                event = 'qb-drugs:client:cornerselling',
                shouldClose = true
            }, {
                id = 'togglehotdogsell',
                title = 'Hotdog vogn',
                icon = 'hotdog',
                type = 'client',
                event = 'qb-hotdogjob:client:ToggleSell',
                shouldClose = true
            }, {
                id = 'interactions',
                title = 'Inteaktioner',
                icon = 'triangle-exclamation',
                items = {
                    {
                        id = 'handcuff',
                        title = 'Sæt i håndjern',
                        icon = 'user-lock',
                        type = 'client',
                        event = 'police:client:CuffPlayerSoft',
                        shouldClose = true
                    }, {
                        id = 'playerinvehicle',
                        title = 'Sæt i køretøj',
                        icon = 'car-side',
                        type = 'client',
                        event = 'police:client:PutPlayerInVehicle',
                        shouldClose = true
                    }, {
                        id = 'playeroutvehicle',
                        title = 'Tag ud af køretøj',
                        icon = 'car-side',
                        type = 'client',
                        event = 'police:client:SetPlayerOutVehicle',
                        shouldClose = true
                    }, {
                        id = 'stealplayer',
                        title = 'Stjæl',
                        icon = 'mask',
                        type = 'client',
                        event = 'police:client:RobPlayer',
                        shouldClose = true
                    }, {
                        id = 'escort',
                        title = 'Kidnap',
                        icon = 'user-group',
                        type = 'client',
                        event = 'police:client:KidnapPlayer',
                        shouldClose = true
                    }, {
                        id = 'escort2',
                        title = 'Eskortér',
                        icon = 'user-group',
                        type = 'client',
                        event = 'police:client:EscortPlayer',
                        shouldClose = true
                    }, {
                        id = 'escort554',
                        title = 'Gidsel',
                        icon = 'child',
                        type = 'client',
                        event = 'A5:Client:TakeHostage',
                        shouldClose = true
                    }
                }
            }
        }
    },
    [2] = {
        id = 'general',
        title = 'Generelt',
        icon = 'rectangle-list',
        items = {
            {
                id = 'house',
                title = 'Hus menu',
                icon = 'house',
                items = {
                    {
                        id = 'givehousekey',
                        title = 'Giv husnøgler',
                        icon = 'key',
                        type = 'client',
                        event = 'qb-houses:client:giveHouseKey',
                        shouldClose = true
                    }, {
                        id = 'removehousekey',
                        title = 'Fjern husnøgler',
                        icon = 'key',
                        type = 'client',
                        event = 'qb-houses:client:removeHouseKey',
                        shouldClose = true
                    }, {
                        id = 'togglelock',
                        title = 'Åben/lås dør',
                        icon = 'door-closed',
                        type = 'client',
                        event = 'qb-houses:client:toggleDoorlock',
                        shouldClose = true
                    }, {
                        id = 'decoratehouse',
                        title = 'Dekorér hus',
                        icon = 'box',
                        type = 'client',
                        event = 'qb-houses:client:decorate',
                        shouldClose = true
                    }, {
                        id = 'houseLocations',
                        title = 'Interaktions muligheder',
                        icon = 'house',
                        items = {
                            {
                                id = 'setstash',
                                title = 'Placér lager',
                                icon = 'box-open',
                                type = 'client',
                                event = 'qb-houses:client:setLocation',
                                shouldClose = true
                            }, {
                                id = 'setoutift',
                                title = 'Sæt omklædning',
                                icon = 'shirt',
                                type = 'client',
                                event = 'qb-houses:client:setLocation',
                                shouldClose = true
                            }, {
                                id = 'setlogout',
                                title = 'Sæt log ud',
                                icon = 'door-open',
                                type = 'client',
                                event = 'qb-houses:client:setLocation',
                                shouldClose = true
                            }
                        }
                    }
                }
            }, {
                id = 'clothesmenu',
                title = 'Beklædning',
                icon = 'shirt',
                items = {
                    {
                        id = 'Hair',
                        title = 'Hår',
                        icon = 'user',
                        type = 'client',
                        event = 'qb-radialmenu:ToggleClothing',
                        arg = {id = 'Hair'},
                        shouldClose = true
                    }, {
                        id = 'Ear',
                        title = 'Øre bling',
                        icon = 'ear-deaf',
                        type = 'client',
                        event = 'qb-radialmenu:ToggleProps',
                        arg = 'Ear',
                        shouldClose = true
                    }, {
                        id = 'Neck',
                        title = 'Nakke',
                        icon = 'user-tie',
                        type = 'client',
                        event = 'qb-radialmenu:ToggleClothing',
                        arg = {id = 'Neck'},
                        shouldClose = true
                    }, {
                        id = 'Top',
                        title = 'Top',
                        icon = 'shirt',
                        type = 'client',
                        event = 'qb-radialmenu:ToggleClothing',
                        arg = {id = 'Top'},
                        shouldClose = true
                    }, {
                        id = 'Shirt',
                        title = 'TShirt',
                        icon = 'shirt',
                        type = 'client',
                        event = 'qb-radialmenu:ToggleClothing',
                        arg = {id = 'Shirt'},
                        shouldClose = true
                    }, {
                        id = 'Pants',
                        title = 'Bukser',
                        icon = 'user',
                        type = 'client',
                        event = 'qb-radialmenu:ToggleClothing',
                        arg = {id = 'Pants'},
                        shouldClose = true
                    }, {
                        id = 'Shoes',
                        title = 'Sko',
                        icon = 'shoe-prints',
                        type = 'client',
                        event = 'qb-radialmenu:ToggleClothing',
                        arg = {id = 'Shoes'},
                        shouldClose = true
                    }, {
                        id = 'meer',
                        title = 'Extras',
                        icon = 'plus',
                        items = {
                            {
                                id = 'Hat',
                                title = 'Hat',
                                icon = 'hat-cowboy-side',
                                type = 'client',
                                event = 'qb-radialmenu:ToggleProps',
                                arg = 'Hat',
                                shouldClose = true
                            }, {
                                id = 'Glasses',
                                title = 'Briller',
                                icon = 'glasses',
                                type = 'client',
                                event = 'qb-radialmenu:ToggleProps',
                                arg = 'Glasses',
                                shouldClose = true
                            }, {
                                id = 'Visor',
                                title = 'Visir',
                                icon = 'hat-cowboy-side',
                                type = 'client',
                                event = 'qb-radialmenu:ToggleProps',
                                arg = 'Visor',
                                shouldClose = true
                            }, {
                                id = 'Mask',
                                title = 'Maske',
                                icon = 'masks-theater',
                                type = 'client',
                                event = 'qb-radialmenu:ToggleClothing',
                                arg = {id = 'Mask'},
                                shouldClose = true
                            }, {
                                id = 'Vest',
                                title = 'Vest',
                                icon = 'vest',
                                type = 'client',
                                event = 'qb-radialmenu:ToggleClothing',
                                arg = {id = 'Vest'},
                                shouldClose = true
                            }, {
                                id = 'Bag',
                                title = 'Taske',
                                icon = 'bag-shopping',
                                type = 'client',
                                event = 'qb-radialmenu:ToggleClothing',
                                arg = {id = 'Bag'},
                                shouldClose = true
                            }, {
                                id = 'Bracelet',
                                title = 'Smykker',
                                icon = 'user',
                                type = 'client',
                                event = 'qb-radialmenu:ToggleProps',
                                arg = 'Bracelet',
                                shouldClose = true
                            }, {
                                id = 'Watch',
                                title = 'Armbåndsur',
                                icon = 'stopwatch',
                                type = 'client',
                                event = 'qb-radialmenu:ToggleProps',
                                arg = 'Watch',
                                shouldClose = true
                            }, {
                                id = 'Gloves',
                                title = 'Handsker',
                                icon = 'mitten',
                                type = 'client',
                                event = 'qb-radialmenu:ToggleClothing',
                                arg = {id = 'Gloves'},
                                shouldClose = true
                            }
                        }
                    }
                }
            }
        }
    },
        
}

Config.VehicleDoors = {
    id = 'vehicledoors',
    title = 'Køretøjsdøre',
    icon = 'car-side',
    items = {
        {
            id = 'door0',
            title = 'Førerdør',
            icon = 'car-side',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            arg = 0,
            shouldClose = false
        }, {
            id = 'door4',
            title = 'Kølerhjelm',
            icon = 'car',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            arg = 4,
            shouldClose = false
        }, {
            id = 'door1',
            title = 'Passager dør',
            icon = 'car-side',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            arg = 1,
            shouldClose = false
        }, {
            id = 'door3',
            title = 'Højre bagdør',
            icon = 'car-side',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            arg = 3,
            shouldClose = false
        }, {
            id = 'door5',
            title = 'Bagagerum',
            icon = 'car',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            arg = 5,
            shouldClose = false
        }, {
            id = 'door2',
            title = 'Venstre bagdør',
            icon = 'car-side',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            arg = 2,
            shouldClose = false
        }
    }
}

Config.VehicleExtras = {
    id = 'vehicleextras',
    title = 'Køretøjs ekstra',
    icon = 'plus',
    items = {
        {
            id = 'extra1',
            title = 'Extra 1',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 1,
            shouldClose = false
        }, {
            id = 'extra2',
            title = 'Extra 2',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 2,
            shouldClose = false
        }, {
            id = 'extra3',
            title = 'Extra 3',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 3,
            shouldClose = false
        }, {
            id = 'extra4',
            title = 'Extra 4',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 4,
            shouldClose = false
        }, {
            id = 'extra5',
            title = 'Extra 5',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 5,
            shouldClose = false
        }, {
            id = 'extra6',
            title = 'Extra 6',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 6,
            shouldClose = false
        }, {
            id = 'extra7',
            title = 'Extra 7',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 7,
            shouldClose = false
        }, {
            id = 'extra8',
            title = 'Extra 8',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 8,
            shouldClose = false
        }, {
            id = 'extra9',
            title = 'Extra 9',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 9,
            shouldClose = false
        }, {
            id = 'extra10',
            title = 'Extra 10',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 10,
            shouldClose = false
        }, {
            id = 'extra11',
            title = 'Extra 11',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 11,
            shouldClose = false
        }, {
            id = 'extra12',
            title = 'Extra 12',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 12,
            shouldClose = false
        }, {
            id = 'extra13',
            title = 'Extra 13',
            icon = 'box-open',
            type = 'client',
            event = 'radialmenu:client:setExtra',
            arg = 13,
            shouldClose = false
        }
    }
}

Config.VehicleSeats = {
    id = 'vehicleseats',
    label = 'Køretøjssæder',
    icon = 'chair',
    menu = 'vehicleseatsmenu'
}

Config.JobInteractions = {
    ["ambulance"] = {
        {
            id = 'statuscheck',
            title = 'Tjek helbred',
            icon = 'heart-pulse',
            type = 'client',
            event = 'hospital:client:CheckStatus',
            shouldClose = true
        },{
            id = 'revivep',
            title = 'Genopliv',
            icon = 'user-doctor',
            type = 'client',
            event = 'hospital:client:RevivePlayer',
            shouldClose = true
        },{
            id = 'treatwounds',
            title = 'Rens sår',
            icon = 'bandage',
            type = 'client',
            event = 'hospital:client:TreatWounds',
            shouldClose = true
        }, {
            id = 'emergencybutton2',
            title = 'Panik knap',
            icon = 'bell',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true
        }, {
            id = 'escort',
            title = 'Eskortér',
            icon = 'user-group',
            type = 'client',
            event = 'police:client:EscortPlayer',
            shouldClose = true
        },
    },
    ["taxi"] = {
        {
            id = 'togglemeter',
            title = 'Vis/Gem taxiMeter',
            icon = 'eye-slash',
            type = 'client',
            event = 'qb-taxi:client:toggleMeter',
            shouldClose = false
        }, {
            id = 'togglemouse',
            title = 'Start/Stop taxiMeter',
            icon = 'hourglass-start',
            type = 'client',
            event = 'qb-taxi:client:enableMeter',
            shouldClose = true
        }, {
            id = 'npc_mission',
            title = 'NPC Mission',
            icon = 'taxi',
            type = 'client',
            event = 'qb-taxi:client:DoTaxiNpc',
            shouldClose = true
        }
    },
    ["tow"] = {
        {
            id = 'togglenpc',
            title = 'Toggle NPC',
            icon = 'toggle-on',
            type = 'client',
            event = 'jobs:client:ToggleNpc',
            shouldClose = true
        }, {
            id = 'towvehicle',
            title = 'Træk køretøj',
            icon = 'truck-pickup',
            type = 'client',
            event = 'qb-tow:client:TowVehicle',
            shouldClose = true
        }
    },
    ["mechanic"] = {
        {
            id = 'towvehicle',
            title = 'Træk køretøj',
            icon = 'truck-pickup',
            type = 'client',
            event = 'qb-tow:client:TowVehicle',
            shouldClose = true
        }
    },
    ["police"] = {
        {
            id = 'emergencybutton',
            title = 'Panik knap',
            icon = 'bell',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true
        }, {
            id = 'resethouse',
            title = 'Åben dørlås',
            icon = 'key',
            type = 'client',
            event = 'qb-houses:client:ResetHouse',
            shouldClose = true
        }, {
            id = 'takedriverlicense',
            title = 'Revoke Drivers License',
            icon = 'id-card',
            type = 'client',
            event = 'police:client:SeizeDriverLicense',
            shouldClose = true
        }, {
            id = 'policeinteraction',
            title = 'Police Actions',
            icon = 'list-check',
            items = {
                {
                    id = 'statuscheck',
                    title = 'Tjek helbredsstatus',
                    icon = 'heart-pulse',
                    type = 'client',
                    event = 'hospital:client:CheckStatus',
                    shouldClose = true
                }, {
                    id = 'checkstatus',
                    title = 'Tjek status',
                    icon = 'question',
                    type = 'client',
                    event = 'police:client:CheckStatus',
                    shouldClose = true
                }, {
                    id = 'escort',
                    title = 'Eskortér',
                    icon = 'user-group',
                    type = 'client',
                    event = 'police:client:EscortPlayer',
                    shouldClose = true
                }, {
                    id = 'searchplayer',
                    title = 'Kig i lomme',
                    icon = 'magnifying-glass',
                    type = 'client',
                    event = 'police:client:SearchPlayer',
                    shouldClose = true
                }, {
                    id = 'jailplayer',
                    title = 'Sæt i fængsel',
                    icon = 'user-lock',
                    type = 'client',
                    event = 'police:client:JailPlayer',
                    shouldClose = true
                }
            }
        }, {
            id = 'policeobjects',
            title = 'Objekter',
            icon = 'road',
            items = {
                {
                    id = 'spawnpion',
                    title = 'Kegle',
                    icon = 'triangle-exclamation',
                    type = 'client',
                    event = 'police:client:spawnPObj',
                    arg = 'cone',
                    shouldClose = false
                }, {
                    id = 'spawnhek',
                    title = 'Port',
                    icon = 'torii-gate',
                    type = 'client',
                    event = 'police:client:spawnPObj',
                    arg = 'barrier',
                    shouldClose = false
                }, {
                    id = 'spawnschotten',
                    title = 'Trafik fartskilt',
                    icon = 'sign-hanging',
                    type = 'client',
                    event = 'police:client:spawnPObj',
                    arg = 'roadsign',
                    shouldClose = false
                }, {
                    id = 'spawntent',
                    title = 'Telt',
                    icon = 'campground',
                    type = 'client',
                    event = 'police:client:spawnPObj',
                    arg = 'tent',
                    shouldClose = false
                }, {
                    id = 'spawnverlichting',
                    title = 'Belysning',
                    icon = 'lightbulb',
                    type = 'client',
                    event = 'police:client:spawnPObj',
                    arg = 'light',
                    shouldClose = false
                }, {
                    id = 'spikestrip',
                    title = 'Søm måtte',
                    icon = 'caret-up',
                    type = 'client',
                    event = 'police:client:SpawnSpikeStrip',
                    shouldClose = false
                }, {
                    id = 'deleteobject',
                    title = 'Fjern objekt',
                    icon = 'trash',
                    type = 'client',
                    event = 'police:client:deleteObject',
                    shouldClose = false
                }
            }
        }
    },
    ["hotdog"] = {
        {
            id = 'togglesell',
            title = 'Start/stop salg',
            icon = 'hotdog',
            type = 'client',
            event = 'qb-hotdogjob:client:ToggleSell',
            shouldClose = true
        }
    }
}

Config.GangInteractions = {
    ["lostmc"] = {
        {
            id = 'handcuff',
            title = 'Håndjern',
            icon = 'handcuffs',
            type = 'client',
            event = 'police:client:CuffPlayerSoft',
            shouldClose = true
        },{
            id = 'playerinvehicle',
            title = 'Sæt i køretøj',
            icon = 'car-side',
            type = 'client',
            event = 'police:client:PutPlayerInVehicle',
            shouldClose = true
        }, {
            id = 'playeroutvehicle',
            title = 'Tag ud af køretøj',
            icon = 'car-side',
            type = 'client',
            event = 'police:client:SetPlayerOutVehicle',
            shouldClose = true
        }, {
            id = 'stealplayer',
            title = 'Stjæl',
            icon = 'mask',
            type = 'client',
            event = 'police:client:SearchPlayer', -- If you want to use ox_inventory steal you need to register an event, put: exports.ox_inventory:openNearbyInventory() in the event. Then use the event you registered in this config.
            shouldClose = true
        }, {
            id = 'escort',
            title = 'Kidnap',
            icon = 'user-group',
            type = 'client',
            event = 'police:client:KidnapPlayer',
            shouldClose = true
        }, {
            id = 'escort2',
            title = 'Eskortér',
            icon = 'user-group',
            type = 'client',
            event = 'police:client:EscortPlayer',
            shouldClose = true
        }
    }
}

Config.TrunkClasses = {
    [0] = {allowed = true, x = 0.0, y = -1.5, z = 0.0}, -- Coupes
    [1] = {allowed = true, x = 0.0, y = -2.0, z = 0.0}, -- Sedans
    [2] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- SUVs
    [3] = {allowed = true, x = 0.0, y = -1.5, z = 0.0}, -- Coupes
    [4] = {allowed = true, x = 0.0, y = -2.0, z = 0.0}, -- Muscle
    [5] = {allowed = true, x = 0.0, y = -2.0, z = 0.0}, -- Sports Classics
    [6] = {allowed = true, x = 0.0, y = -2.0, z = 0.0}, -- Sports
    [7] = {allowed = true, x = 0.0, y = -2.0, z = 0.0}, -- Super
    [8] = {allowed = false, x = 0.0, y = -1.0, z = 0.25}, -- Motorcycles
    [9] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Off-road
    [10] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Industrial
    [11] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Utility
    [12] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Vans
    [13] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Cycles
    [14] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Boats
    [15] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Helicopters
    [16] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Planes
    [17] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Service
    [18] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Emergency
    [19] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Military
    [20] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Commercial
    [21] = {allowed = true, x = 0.0, y = -1.0, z = 0.25} -- Trains
}

Config.Commands = {
    ["top"] = {
        Func = function() ToggleClothing({"Top"}) end,
        Sprite = "top",
        Desc = "Tag af/på",
        Button = 1,
        Name = "Torso"
    },
    ["gloves"] = {
        Func = function() ToggleClothing({"Gloves"}) end,
        Sprite = "gloves",
        Desc = "Tag af/på",
        Button = 2,
        Name = "Gloves"
    },
    ["visor"] = {
        Func = function() ToggleProps({"Visor"}) end,
        Sprite = "visor",
        Desc = "Tag af/på",
        Button = 3,
        Name = "Visor"
    },
    ["bag"] = {
        Func = function() ToggleClothing({"Bag"}) end,
        Sprite = "bag",
        Desc = "Åben/luk",
        Button = 8,
        Name = "Bag"
    },
    ["shoes"] = {
        Func = function() ToggleClothing({"Shoes"}) end,
        Sprite = "shoes",
        Desc = "Tag af/på",
        Button = 5,
        Name = "Shoes"
    },
    ["vest"] = {
        Func = function() ToggleClothing({"Vest"}) end,
        Sprite = "vest",
        Desc = "Tag af/på",
        Button = 14,
        Name = "Vest"
    },
    ["hair"] = {
        Func = function() ToggleClothing({"Hair"}) end,
        Sprite = "hair",
        Desc = "Tag hår op/ned.",
        Button = 7,
        Name = "Hair"
    },
    ["hat"] = {
        Func = function() ToggleProps({"Hat"}) end,
        Sprite = "hat",
        Desc = "Tag af/på",
        Button = 4,
        Name = "Hat"
    },
    ["glasses"] = {
        Func = function() ToggleProps({"Glasses"}) end,
        Sprite = "glasses",
        Desc = "Tag af/på",
        Button = 9,
        Name = "Glasses"
    },
    ["ear"] = {
        Func = function() ToggleProps({"Ear"}) end,
        Sprite = "ear",
        Desc = "Tag af/på",
        Button = 10,
        Name = "Ear"
    },
    ["neck"] = {
        Func = function() ToggleClothing({"Neck"}) end,
        Sprite = "neck",
        Desc = "Tag af/på",
        Button = 11,
        Name = "Neck"
    },
    ["watch"] = {
        Func = function() ToggleProps({"Watch"}) end,
        Sprite = "watch",
        Desc = "Tag af/på",
        Button = 12,
        Name = "Watch",
        Rotation = 5.0
    },
    ["bracelet"] = {
        Func = function() ToggleProps({"Bracelet"}) end,
        Sprite = "bracelet",
        Desc = "Tag af/på",
        Button = 13,
        Name = "Bracelet"
    },
    ["mask"] = {
        Func = function() ToggleClothing({"Mask"}) end,
        Sprite = "mask",
        Desc = "Tag af/på",
        Button = 6,
        Name = "Mask"
    }
}

local bags = {[40] = true, [41] = true, [44] = true, [45] = true}

Config.ExtraCommands = {
    ["pants"] = {
        Func = function() ToggleClothing({"Pants", true}) end,
        Sprite = "pants",
        Desc = "Tag af/på",
        Name = "Pants",
        OffsetX = -0.04,
        OffsetY = 0.0
    },
    ["shirt"] = {
        Func = function() ToggleClothing({"Shirt", true}) end,
        Sprite = "shirt",
        Desc = "Tag af/på",
        Name = "shirt",
        OffsetX = 0.04,
        OffsetY = 0.0
    },
    ["reset"] = {
        Func = function()
            if not ResetClothing(true) then
                Notify('Nothing To Reset', 'error')
            end
        end,
        Sprite = "reset",
        Desc = "Nulstil outfit",
        Name = "reset",
        OffsetX = 0.12,
        OffsetY = 0.2,
        Rotate = true
    },
    ["bagoff"] = {
        Func = function() ToggleClothing({"Bagoff", true}) end,
        Sprite = "bagoff",
        SpriteFunc = function()
            local Bag = GetPedDrawableVariation(cache.ped, 5)
            local BagOff = LastEquipped["Bagoff"]
            if LastEquipped["Bagoff"] then
                if bags[BagOff.Drawable] then
                    return "bagoff"
                else
                    return "paraoff"
                end
            end
            if Bag ~= 0 then
                if bags[Bag] then
                    return "bagoff"
                else
                    return "paraoff"
                end
            else
                return false
            end
        end,
        Desc = "Tag af/på",
        Name = "bagoff",
        OffsetX = -0.12,
        OffsetY = 0.2
    }
}
