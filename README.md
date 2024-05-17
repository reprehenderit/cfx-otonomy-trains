# FiveM Train Script

Train Management System for FiveM.

## Installation 
 
Add line below to your server.cfg

```cfg
ensure trains
```

## Features

- Spawn trains at specific locations
- Synchronize train positions and speeds
- Delete trains and their blips
- Display trains on the map with blips

## Configuration

```lua
Config = {}

-- Trains spawn coordinates
Config.TrainSpawns = {
    { x = 2533.0, y = 2833.0, z = 38.0},
    { x = 2606.0, y = 2927.0, z = 40.0},
    { x = 2463.0, y = 3872.0, z = 38.8},
    { x = 1164.0, y = 6433.0, z = 32.0}
}

-- Train speed
Config.TrainSpeed = 20.0

-- Train blips
Config.TrainBlips = true
```

## Client-Side Events

| Event           | Description                                  |
| --------------- | -------------------------------------------- |
| `trains:spawn`  | Spawns a train at the specified coordinates. |
| `trains:sync`   | Syncs the train data across all clients.     |
| `trains:delete` | Deletes the specified train.                 |

## Server-Side Events

| Event                | Description                                             |
| -------------------- | ------------------------------------------------------- |
| `trains:update`      | Updates the train data and syncs it across all clients. |
| `trains:playerReady` | Initializes trains when the first player joins.         |

## Contributing

- Feel free to contribute as long as you don't break things.

## License

This project is licensed under the MIT License.