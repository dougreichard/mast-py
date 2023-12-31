#
# Rather than load files I just use string
#

file_one = """
x = 2
shared z = 2
jump start
==== start ====
for x in range(3):
    y = x


for x while x>y:
    y = x


match friendly_select:
    case "many":
        max_hull_points=20
    case "lots":
        max_hull_points=15
    case "some":
        max_hull_points=10
    case "few":
        max_hull_points=5
    case "none":
        ->RETURN
"""

file_two = """
======== player_docking  ===================

if not object_exists(sim, self):
    log("Docking ship died")
    ->END

player_blob = get_engine_data_set(sim, self)
dock_state_string = get_data_set_value(player_blob,"dock_state", 0)

if "undocked" == dock_state_string:
    #set_data_set_value(player_blob, "dock_base_id", 0)
    dock_rng = 600
    station = closest(self, role("Station"), 600)
    if station is not None:
        set_data_set_value(player_blob, "dock_base_id", to_id(station))

dock_stationID = get_data_set_value(player_blob, "dock_base_id", 0)
dock_station = to_object(dock_stationID)
if dock_station is not None:
    if "docking" == dock_state_string:
        # check to see if the player ship is close enough to be docked
        distanceValue = sbs.distance_id(dock_station.id, self.id)
        closeEnough = dock_station.get_space_object(sim).exclusion_radius + self.get_space_object(sim).exclusion_radius
        closeEnough = closeEnough * 1.1
        if distanceValue <= closeEnough:
            set_data_set_value(player_blob, "dock_state", "docked")


if "docked" == dock_state_string:
    dock_station_blob = get_engine_data_set(sim, dock_station)
    # refuel
    fuel_value = get_data_set_value(player_blob, "energy",0)
    fuel_value = fuel_value + 20
    if fuel_value > 1000:
        fuel_value = 1000
    set_data_set_value(player_blob, "energy", int(fuel_value))

    # resupply torps
    for torps in range(sbs.TORPEDO.MINE):
        tLeft =  get_data_set_value(dock_station_blob,"torpedo_count", torps)
        if tLeft > 0:
            torp_max = get_data_set_value(player_blob,"torpedo_max", torps)
            torp_now = get_data_set_value(player_blob,"torpedo_count", torps)
            if torp_now < torp_max:
                torp_now = torp_now + 1
                set_data_set_value(player_blob,"torpedo_count", torp_now,torps)
                set_data_set_value(dock_station_blob,"torpedo_count", tLeft-1, torps)

    shieldCoeff = get_data_set_value(player_blob,"repair_rate_shields",0)
    systemCoeff = get_data_set_value(player_blob,"repair_rate_systems",0)

    sCount = get_data_set_value(player_blob,"shield_count",0)
    for shield in range(sCount-1):
        sVal = get_data_set_value(player_blob,"shield_val", shield)
        sValMax = get_data_set_value(player_blob,"shield_max_val", shield)
        changed = (sVal < sValMax)
        sVal = max(0.0, min(sVal + shieldCoeff, sValMax)) # clamp the value
        if changed:
            set_data_set_value(player_blob,"shield_val", sVal, shield)

    #repair systems (more than normal)
    for system in range(sbs.SHPSYS.SHIELDS):
        damage = get_data_set_value(player_blob,"system_damage", system)
        maxDamage = get_data_set_value(player_blob,"system_max_damage", system)
        changed = (damage > 0.0)
        damage = max(0.0, min(damage - systemCoeff, maxDamage)) # clamp the value
        if changed:
            set_data_set_value(player_blob,"system_damage", damage, system)

await delay_sim(5)

x[1] == 1
-> player_docking
"""