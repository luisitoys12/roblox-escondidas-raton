-- ToolData.lua v2.0 — 20 herramientas únicas
local ToolData = {
    -- ══ RATÓN (10 herramientas) ══
    { id="lantern",       name="Linterna",          role="Mouse", price=50,   cooldown=0,  description="Ilumina zonas oscuras.",                      effect="light" },
    { id="trap",          name="Trampa",             role="Mouse", price=150,  cooldown=30, description="Inmoviliza al escondido 3 seg al pisarla.",    effect="placeTrap" },
    { id="radar",         name="Radar",              role="Mouse", price=200,  cooldown=45, description="Muestra posición de todos 5 seg.",            effect="radar" },
    { id="speed_pill",    name="Píldora de Velocidad",role="Mouse",price=120,  cooldown=40, description="+8 velocidad durante 5 seg.",                 effect="speedBoost" },
    { id="magnet",        name="Imán",               role="Mouse", price=300,  cooldown=60, description="Atrae al escondido más cercano hacia ti.",    effect="magnet" },
    { id="freeze_bomb",   name="Bomba Helada",        role="Mouse", price=250,  cooldown=50, description="Congela a todos los escondidos en 10m 3 seg.",effect="freezeArea" },
    { id="scanner",       name="Escáner",             role="Mouse", price=180,  cooldown=35, description="Revela escondidos a través de paredes 3 seg.",effect="wallhack" },
    { id="drone",         name="Dron",                role="Mouse", price=400,  cooldown=90, description="Vuela sobre el mapa 10 seg viendo todo.",     effect="droneView" },
    { id="noise_maker",   name="Emisor de Ruido",     role="Mouse", price=100,  cooldown=25, description="Hace sonar una alarma en posición aleatoria.", effect="noiseMaker" },
    { id="double_tap",    name="Doble Captura",       role="Mouse", price=500,  cooldown=120,description="Siguiente captura vale doble.",              effect="doubleCapture" },
    -- ══ ESCONDIDO (10 herramientas) ══
    { id="decoy",         name="Señuelo",             role="Hider", price=100,  cooldown=25, description="Distrae al Ratón 5 seg.",                    effect="spawnDecoy" },
    { id="smoke",         name="Bomba de Humo",       role="Hider", price=120,  cooldown=30, description="Nube de humo 4 seg.",                        effect="smokeCloud" },
    { id="dash",          name="Dash",                role="Hider", price=80,   cooldown=15, description="Impulso rápido hacia adelante.",              effect="dash" },
    { id="invisibility",  name="Poción Invisible",    role="Hider", price=350,  cooldown=60, description="Invisible 4 seg (no al moverse rápido).",    effect="invisible" },
    { id="disguise",      name="Disfraz",             role="Hider", price=280,  cooldown=50, description="Te convierte en un objeto del mapa 5 seg.",  effect="disguise" },
    { id="teleport",      name="Teletransporte",      role="Hider", price=400,  cooldown=80, description="Teletransporta a punto aleatorio del mapa.",  effect="teleport" },
    { id="shield_bubble", name="Burbuja Escudo",      role="Hider", price=300,  cooldown=70, description="Absorbe 1 captura del Ratón.",               effect="shieldBubble" },
    { id="speed_shoes",   name="Zapatos Turbo",       role="Hider", price=150,  cooldown=35, description="+6 velocidad 6 seg.",                        effect="speedShoes" },
    { id="clone",         name="Clon",                role="Hider", price=500,  cooldown=100,description="Crea un clon que corre en dirección opuesta.",effect="spawnClone" },
    { id="emp",           name="EMP",                 role="Hider", price=450,  cooldown=90, description="Desactiva todas las herramientas del Ratón 5 seg.", effect="emp" },
}
return ToolData
