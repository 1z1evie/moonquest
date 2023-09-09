

function game.update()
    player_update()
    player_animate()
    add_splashes_at_random(10)
    for splash in all(splashes) do
        splash:update()
    end
    for u in all(umb) do
        u:update()
    end
    cam_update()
    for m in all(moons) do
        m:update()
    end
    for f in all(flags) do
        f:update()
    end
    for r in all(rain) do
        r:update()
    end
    for g in all(graphics) do
        g:update()
    end
    for spike in all(floating_spikes) do 
        spike:update()
    end
    for s in all(signs) do 
        s:update()
    end
    if debug_on then
        debug_update()
    end
    if not controls_on then
        pause_controls_end = time()
        if pause_controls_end - pause_controls_start >= pause_controls_duration then
            controls_on = true
        end
    end
end

function game.draw()
    cls(0)
    for drop in all(rain) do
        drop:draw()
    end
    map(0,0)
    --print("jump : ❎", 1 * 8, 59 * 8, 7)
    --print("float : ❎ [while falling]", 24 * 8, 59 * 8, 7)
    for splash in all(splashes) do
        splash:draw()
    end
    for u in all(umb) do
        u:draw()
    end
    for m in all(moons) do
        m:draw()
    end
    for f in all(flags) do
        f:draw()
    end
    for spike in all(floating_spikes) do 
        spike:draw()
    end
    spr(player.current_sprite, player.x, player.y, 1, 1, player.flp)
    drw_flt_mtr()
    for i = 1, #enm do
        local myenm=enm[i]
        spr(myenm.spr, myenm.x, myenm.y)	
    end
    draw_moon_counter(num_moons_collected)
    draw_death_counter(num_deaths)
    for g in all(graphics) do
        g:draw()
    end
    if debug_on then
        debug_draw()
    end
    for s in all(signs) do 
        s:draw()
    end
end

function game.reset()
    local spawn_x, spawn_y, spawn_at_flag = false
    for f in all(flags) do
        if f.up == true then
            spawn_x = f.x
            spawn_y = f.y
            spawn_at_flag = true
        end
    end
    if not spawn_at_flag then
        player_init(default_spawn_x, default_spawn_y)
        cam_init(default_spawn_x, default_spawn_y)
    else
        cam_init(spawn_x, spawn_y)
        player_init(spawn_x, spawn_y)
    end
    umb = {}
    add_umb()
    rain={}
    for i = 1, 100 do
        add_rain()
    end
    enm={}
    local my_en={}
    my_en.x=90
    my_en.y=20
    my_en.spr=54
    add(enm, my_en)
end

function game.init()
    music(0)
    graphics = {}
    num_moons_collected = 0
    moons = {}
    flags = {}
    for tile_x = 0, 127 do
        for tile_y = 0, 127 do 
            if fget(mget(tile_x, tile_y), moon_flag) then
                add_moon(tile_x * 8, tile_y * 8)
            elseif fget(mget(tile_x, tile_y), save_flag) then
                add_flag(tile_x, tile_y)
            end
        end
    end
    floating_spikes = {}
    add_all_spikes()
    signs = {}
    splashes = {}
    init_signs()
    player_init(default_spawn_x, default_spawn_y)
    game.reset()
    num_deaths = 0
    controls_on = true
end