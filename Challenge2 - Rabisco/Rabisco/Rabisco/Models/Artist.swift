//
//  Artist.swift
//  Rabisco
//
//  Created by Caio on 13/11/25.
//

import Foundation

enum ArtistTopic: String, Codable {
    case Food, Animals, Objects, Places, Pop, Random
    
    func sfSymbol() -> String {
        switch self {
        case .Food:
            return "carrot"
        case .Animals:
            return "pawprint"
        case .Objects:
            return "volleyball"
        case .Places:
            return "location"
        case .Pop:
            return "movieclapper"
        case .Random:
            return "dice"
        }
    }
    
    func getRandomTopic() -> String {
        switch self {
        case .Food:
            return [
                "Burger","Pizza","Sushi","Taco","Ramen","Noodles","Donut","Croissant","Bagel","Pancake",
                "Waffle","Steak","Fries","Popcorn","Hotdog","Cheesecake","Brownie","Cookie","Salad","Cereal",
                "Yogurt","Milkshake","Chocolate","Marshmallow","Carrot","Lettuce","Broccoli","Tomato","Egg",
                "Bacon","Sausage","Shrimp","Lobster","Salmon","Tuna","Grapes","Apple","Banana","Pear",
                "Orange","Lemon","Lime","Watermelon","Pineapple","Coconut","Kiwi","Mango","Papaya","Strawberry",
                "Blueberry","Raspberry","Avocado","Onion","Garlic","Pepper","Rice","Beans","Corn","Peas",
                "Pumpkin","Olive","Cheese","Butter","Cream","Honey","Jam","Syrup","Vinegar","Ketchup",
                "Mustard","Mayonnaise","Pasta","Lasagna","Paella","Risotto","Dumpling","Gyoza","Burrito","Quesadilla",
                "Falafel","Hummus","Tortilla","Pretzel","Scone","Fondue","Gelato","Sorbet","Barbecue","Popsicle",
                "Churro","Mochi","Wasabi","Kimchi","Tofu","Tempeh","Caviar","Pesto","Guacamole","Ceviche",
            ].randomElement()!
        case .Animals:
            return [
                "Cat","Dog","Fish","Bird","Horse","Cow","Sheep","Goat","Pig","Chicken",
                "Duck","Goose","Turkey","Bee","Ant","Spider","Fly","Butterfly","Moth","Mosquito",
                "Lion","Tiger","Leopard","Cheetah","Bear","Wolf","Fox","Hyena","Elephant","Rhino",
                "Hippo","Giraffe","Zebra","Monkey","Gorilla","Orangutan","Kangaroo","Koala","Panda","Sloth",
                "Dolphin","Whale","Shark","Seal","Otter","Penguin","Turtle","Snake","Lizard","Frog",
                "Toad","Eagle","Hawk","Owl","Parrot","Flamingo","Swan","Peacock","Vulture","Stork",
                "Camel","Alpaca","Donkey","Mule","Buffalo","Bison","Reindeer","Moose","Deer","Boar",
                "Hedgehog","Hamster","Mouse","Rat","Squid","Octopus","Crab","Lobster","Jellyfish","Starfish",
                "Shrimp","Clownfish","Stingray","Seahorse","Meerkat","Armadillo","Platypus","Badger","Skunk","Weasel",
                "Ferret","Beaver","Bat","Mole","Crow","Robin","Sparrow","Pigeon","Cobra","Iguana",
            ].randomElement()!
        case .Objects:
            return [
                "Phone","Laptop","Tablet","Keyboard","Mouse","Monitor","Headphones","Camera","Microphone","Speaker",
                "Book","Notebook","Pen","Pencil","Marker","Eraser","Ruler","Scissors","Glue","Tape",
                "Chair","Table","Sofa","Bed","Pillow","Blanket","Lamp","Mirror","Clock","TV",
                "Remote","Umbrella","Wallet","Key","Watch","Ring","Bracelet","Necklace","Helmet","Backpack",
                "Suitcase","Bottle","Cup","Mug","Plate","Fork","Spoon","Knife","Pan","Pot",
                "Broom","Brush","Toothbrush","Soap","Shampoo","Towel","Bucket","Ladder","Hammer","Screwdriver",
                "Wrench","Drill","Nail","Saw","Flashlight","Tent","Compass","Map","Rope","Binoculars",
                "Guitar","Piano","Violin","Drum","Trumpet","Flute","Saxophone","Microchip","Console","Controller",
                "Joystick","Dice","Card","Balloon","Kite","Puzzle","Chess","Trophy","Medal","Telescope",
            ].randomElement()!
        case .Places:
            return [
                "Paris","London","Rome","Tokyo","New York","Rio","Berlin","Madrid","Athens","Lisbon",
                "Cairo","Mexico City","Buenos Aires","Sydney","Melbourne","Dubai","Singapore","Bangkok","Istanbul","Toronto",
                "Chicago","Los Angeles","Hong Kong","Seoul","Amsterdam",
                "Hospital","School","Library","Museum","Airport","Train Station","Subway","Temple","Church","Mosque",
                "Park","Beach","Forest","Desert","Mountain","Volcano","Island","Village","Farm","Castle",
                "Stadium","Theater","Cinema","Restaurant","Cafe","Bakery","Market","Harbor","Bridge","Tower",
                "Lighthouse","Mine","Cave","Hotel","Office","Factory","Laboratory","Zoo","Aquarium","Cemetery",
                "Skyscraper","Mall","Playground","Campus","Kitchen","Living Room","Garage","Basement","Attic","Rooftop",
                "Highway","Tunnel","Garden","Greenhouse","Waterfall","Cliff","River","Lake","Swamp","Canyon",
                "Fjord","Jungle","Savanna","Oasis","Observatory","Planetarium","Arena","Court","Gym","Spa",
            ].randomElement()!
        case .Pop:
            return [
                "Superhero","Villain","Sidekick","Masked Hero","Cape","Mask","Shield","Laser Gun","Lightsaber","Magic Wand",
                "Spaceship","UFO","Robot","Alien","Time Machine","Portal","Teleporter","Hoverboard","Jetpack","Ray Gun",
                "Dragon","Wizard","Witch","Elf","Dwarf","Orc","Goblin","Troll","Giant","Demon",
                "Zombie","Vampire","Werewolf","Monster","Ghost","Mummy","Frankenstein","Mad Scientist","Lab Coat","Potion",
                "Ninja","Samurai","Kung Fu Master","Assassin","Spy","Secret Agent","Detective","Cowboy","Outlaw","Sheriff",
                "Pirate","Captain","Treasure Map","Treasure Chest","Pirate Ship","Parrot","Hook Hand","Eye Patch","Skull Flag","Cannon",
                "Princess","Prince","King","Queen","Crown","Castle","Throne","Royal Cape","Scepter","Kingdom",
                "Rockstar","Guitarist","Drummer","Microphone","Stage","Concert","Headphones","Vinyl Record","Boombox","Guitar Hero",
                "Gamer","Joystick","Console","Arcade","Power Up","Health Bar","Boss Battle","Game Over","High Score","Pixel Art",
                "Movie Camera","Director Chair","Clapperboard","Red Carpet","Oscar","Popcorn","3D Glasses","Movie Theater","Action Scene","Explosion"
            ].randomElement()!
        case .Random:
            return ["Burger","Pizza","Sushi","Taco","Ramen","Noodles","Donut","Croissant","Bagel","Pancake",
             "Waffle","Steak","Fries","Popcorn","Hotdog","Cheesecake","Brownie","Cookie","Salad","Cereal",
             "Yogurt","Milkshake","Chocolate","Marshmallow","Carrot","Lettuce","Broccoli","Tomato","Egg",
             "Bacon","Sausage","Shrimp","Lobster","Salmon","Tuna","Grapes","Apple","Banana","Pear",
             "Orange","Lemon","Lime","Watermelon","Pineapple","Coconut","Kiwi","Mango","Papaya","Strawberry",
             "Blueberry","Raspberry","Avocado","Onion","Garlic","Pepper","Rice","Beans","Corn","Peas",
             "Pumpkin","Olive","Cheese","Butter","Cream","Honey","Jam","Syrup","Vinegar","Ketchup",
             "Mustard","Mayonnaise","Pasta","Lasagna","Paella","Risotto","Dumpling","Gyoza","Burrito","Quesadilla",
             "Falafel","Hummus","Tortilla","Pretzel","Scone","Fondue","Gelato","Sorbet","Barbecue","Popsicle",
             "Churro","Mochi","Wasabi","Kimchi","Tofu","Tempeh","Caviar","Pesto","Guacamole","Ceviche", "Phone","Laptop","Tablet","Keyboard","Mouse","Monitor","Headphones","Camera","Microphone","Speaker",
             "Book","Notebook","Pen","Pencil","Marker","Eraser","Ruler","Scissors","Glue","Tape",
             "Chair","Table","Sofa","Bed","Pillow","Blanket","Lamp","Mirror","Clock","TV",
             "Remote","Umbrella","Wallet","Key","Watch","Ring","Bracelet","Necklace","Helmet","Backpack",
             "Suitcase","Bottle","Cup","Mug","Plate","Fork","Spoon","Knife","Pan","Pot",
             "Broom","Brush","Toothbrush","Soap","Shampoo","Towel","Bucket","Ladder","Hammer","Screwdriver",
             "Wrench","Drill","Nail","Saw","Flashlight","Tent","Compass","Map","Rope","Binoculars",
             "Guitar","Piano","Violin","Drum","Trumpet","Flute","Saxophone","Microchip","Console","Controller",
             "Joystick","Dice","Card","Balloon","Kite","Puzzle","Chess","Trophy","Medal","Telescope", "Paris","London","Rome","Tokyo","New York","Rio","Berlin","Madrid","Athens","Lisbon",
             "Cairo","Mexico City","Buenos Aires","Sydney","Melbourne","Dubai","Singapore","Bangkok","Istanbul","Toronto",
             "Chicago","Los Angeles","Hong Kong","Seoul","Amsterdam",
             "Hospital","School","Library","Museum","Airport","Train Station","Subway","Temple","Church","Mosque",
             "Park","Beach","Forest","Desert","Mountain","Volcano","Island","Village","Farm","Castle",
             "Stadium","Theater","Cinema","Restaurant","Cafe","Bakery","Market","Harbor","Bridge","Tower",
             "Lighthouse","Mine","Cave","Hotel","Office","Factory","Laboratory","Zoo","Aquarium","Cemetery",
             "Skyscraper","Mall","Playground","Campus","Kitchen","Living Room","Garage","Basement","Attic","Rooftop",
             "Highway","Tunnel","Garden","Greenhouse","Waterfall","Cliff","River","Lake","Swamp","Canyon",
             "Fjord","Jungle","Savanna","Oasis","Observatory","Planetarium","Arena","Court","Gym","Spa", "Superhero","Villain","Sidekick","Masked Hero","Cape","Mask","Shield","Laser Gun","Lightsaber","Magic Wand",
            "Spaceship","UFO","Robot","Alien","Time Machine","Portal","Teleporter","Hoverboard","Jetpack","Ray Gun",
            "Dragon","Wizard","Witch","Elf","Dwarf","Orc","Goblin","Troll","Giant","Demon",
            "Zombie","Vampire","Werewolf","Monster","Ghost","Mummy","Frankenstein","Mad Scientist","Lab Coat","Potion",
            "Ninja","Samurai","Kung Fu Master","Assassin","Spy","Secret Agent","Detective","Cowboy","Outlaw","Sheriff",
            "Pirate","Captain","Treasure Map","Treasure Chest","Pirate Ship","Parrot","Hook Hand","Eye Patch","Skull Flag","Cannon",
            "Princess","Prince","King","Queen","Crown","Castle","Throne","Royal Cape","Scepter","Kingdom",
            "Rockstar","Guitarist","Drummer","Microphone","Stage","Concert","Headphones","Vinyl Record","Boombox","Guitar Hero",
            "Gamer","Joystick","Console","Arcade","Power Up","Health Bar","Boss Battle","Game Over","High Score","Pixel Art",
            "Movie Camera","Director Chair","Clapperboard","Red Carpet","Oscar","Popcorn","3D Glasses","Movie Theater","Action Scene","Explosion"].randomElement()!
        }
    }
}

struct Artist: Codable, Identifiable {
    let id: UUID
    var name: String
    var favoriteTopic: ArtistTopic
    var isActive: Bool = true
    
    init(_ name: String, favoriteTopic: ArtistTopic = .Random) {
        self.id = UUID()
        self.name = name
        self.favoriteTopic = favoriteTopic
        self.isActive = true
    }
}
