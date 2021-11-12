extends Node

# Control modes
enum CONTROL_MODE {MOVE, LOOK, TARGET}
# Entity statuses
enum STATUS {ALIVE, DEAD}
# Entity info types
enum ENTITY_TYPE {ACTOR, ITEM, OBJECT}
# Syringe types
enum SYRINGE_TYPE {DEFENSE_S, DEFENSE_L, HEALTH_S, HEALTH_L}
# Enemy types
enum ENEMY_TYPE {BOMBLING, CYBERTEMPLAR, SHIELDBOT, ZOMBIE}
# Ally types
enum ALLY_TYPE {TURRET, HEALINGBOT}
# Damage skill types
enum DAMAGE_SKILL_TYPE {BOMB, SHOOT}
# Look / Target tiles
enum TARGET_TILES {SELECTABLE, TARGET, LOOK, INVALID_TARGET}
