// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IHiveFactory.sol";

contract GameMap {
    // Define the Area and ItemType enums
    enum Area {
        Crystaline_Canyons,
        Mistveil_Marshes,
        Suncatcher_Plains,
        Frostwhisper_Expanse
    }
    enum ItemType {
        Nectar,
        Pollen,
        Sap
    }

    // Define the Item struct
    struct Item {
        ItemType itemType; // Add the 'itemType' field to the Item struct
        uint256 rate; // Rate represented as a percentage (e.g., 10 means 10%)
    }

    // Define the Hive struct
    struct Hive {
        uint256 hiveId; // Add the 'hiveId' field to the Hive struct
        Area area; // Add the 'area' field to the Hive struct
        mapping(ItemType => uint256) itemQuantities; // Track collected item quantities
    }

    mapping(Area => Item[]) public areaItems;
    mapping(uint256 => Hive) public hives;

    event ItemCollected(uint256 hiveId, ItemType itemType, uint256 amount);

    IHiveFactory public hiveFactory;

    constructor(address _hiveFactory) {
        // Initialize the rates for each area and item type
        areaItems[Area.Crystaline_Canyons].push(Item(ItemType.Nectar, 30));
        areaItems[Area.Crystaline_Canyons].push(Item(ItemType.Pollen, 40));
        areaItems[Area.Crystaline_Canyons].push(Item(ItemType.Sap, 30));

        areaItems[Area.Mistveil_Marshes].push(Item(ItemType.Nectar, 20));
        areaItems[Area.Mistveil_Marshes].push(Item(ItemType.Pollen, 50));
        areaItems[Area.Mistveil_Marshes].push(Item(ItemType.Sap, 30));

        areaItems[Area.Suncatcher_Plains].push(Item(ItemType.Nectar, 40));
        areaItems[Area.Suncatcher_Plains].push(Item(ItemType.Pollen, 30));
        areaItems[Area.Suncatcher_Plains].push(Item(ItemType.Sap, 30));

        areaItems[Area.Frostwhisper_Expanse].push(Item(ItemType.Nectar, 50));
        areaItems[Area.Frostwhisper_Expanse].push(Item(ItemType.Pollen, 20));
        areaItems[Area.Frostwhisper_Expanse].push(Item(ItemType.Sap, 30));

        // Initialize the HiveFactory contract
        hiveFactory = IHiveFactory(_hiveFactory);
    }
    // Create hive function that call to createHive function in HiveFactory.sol
    function createHive(Area area) public {
        uint256 hiveId = hiveFactory.createHive();
        hives[hiveId].hiveId = hiveId;
        // Set the hive's area
        hives[hiveId].area = area;
    }

    // Simulation for the forage
    function collectItem(uint256 hiveId, Area area, uint256 randomSeed) public {
        require(
            hiveId > 0 && hiveId < hiveFactory.totalHives(),
            "Invalid hive ID"
        );

        // Get a random item type from the specified area
        ItemType itemType = getRandomItem(area, randomSeed);

        // Increment the item quantity for the hive
        hives[hiveId].itemQuantities[itemType]++;

        emit ItemCollected(hiveId, itemType, 1); // Emit event for item collection
    }

    function getRandomItem(
        Area area,
        uint256 randomSeed
    ) internal view returns (ItemType) {
        uint256 totalWeight = 100; // Total percentage weight

        // Get a pseudo-random number within the total weight
        uint256 randomNumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, randomSeed))
        ) % totalWeight;

        uint256 cumulativeWeight = 0;
        for (uint256 i = 0; i < areaItems[area].length; i++) {
            cumulativeWeight += areaItems[area][i].rate;
            if (randomNumber < cumulativeWeight) {
                return areaItems[area][i].itemType;
            }
        }

        revert("Invalid random number generation");
    }

    function getHiveItems(
        uint256 hiveId
    ) public view returns (uint256 nectar, uint256 pollen, uint256 sap) {
        require(
            hiveId > 0 && hiveId < hiveFactory.totalHives(),
            "Invalid hive ID"
        );

        Hive storage hive = hives[hiveId];
        return (
            hive.itemQuantities[ItemType.Nectar],
            hive.itemQuantities[ItemType.Pollen],
            hive.itemQuantities[ItemType.Sap]
        );
    }
}
