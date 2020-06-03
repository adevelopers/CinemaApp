//
//  MovieService.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 28.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import Foundation



final class MovieService {
    func movies() -> [Movie] {
        return [
            Movie(screenshots: [ "blade_runner_1",
                                 "blade_runner_2",
                                 "blade_runner_3",
                                 "blade_runner_4",
                                 "blade_runner_5"],
                  title: "Blade \nRunner 2049",
                  janrs: ["Mystery", "Sci-Fi", "Thriller"],
                  type: "3D",
                  note: "A young blade runner, lorem ipsum blalbla Once the display link is associated with a run loop, the selector on the target is called when the screen’s contents need to be updated. The target can read the display link’s timestamp property to retrieve the time that the previous frame was displayed. franchise created by George Lucas, which began with the eponymous 1977 film and quickly became a worldwide pop-culture phenomenon. The franchise has been expanded into various films and other media, including television series, video games, novels, comic books, theme park attractions, and themed areas, comprising an all-encompassing fictional universe.[b] The franchise holds a Guinness World Records title for the 'Most successful film merchandising franchise.' In 2020, the Star Wars franchise's total value was estimated at US$70 billion, and it is currently the fifth-highest-grossing media franchise of all time. \n\nA young blade runner, lorem ipsum blalbla Once the display link is associated with a run loop, the selector on the target is called when the screen’s contents need to be updated. The target can read the display link’s timestamp property to retrieve the time that the previous frame was displayed. franchise created by George Lucas, which began with the eponymous 1977 film and quickly became a worldwide pop-culture phenomenon. The franchise has been expanded into various films and other media, including television series, video games, novels, comic books, theme park attractions, and themed areas, comprising an all-encompassing fictional universe.[b] The franchise holds a Guinness World Records title for the 'Most successful film merchandising franchise.' In 2020, the Star Wars franchise's total value was estimated at US$70 billion, and it is currently the fifth-highest-grossing media franchise of all time."),
            Movie(screenshots: [ "avatar_1", "avatar_2", "avatar_3", "avatar_4"],
                  title: "Avatar\nII",
                  janrs: ["Fantasy"],
                  type: "2D",
                  note: "Avatar (marketed as James Cameron's Avatar) is a 2009 American epic science fiction film directed, written, produced, and co-edited by James Cameron and stars Sam Worthington, Zoe Saldana, Stephen Lang, Michelle Rodriguez, and Sigourney Weaver."),
            Movie(screenshots: ["sw_1", "sw_2", "sw_3", "sw_4", "sw_5"],
                  title: "Star\nWars",
                  janrs: ["Fantastic"],
                  type: "2D",
                  note: "Star Wars is an American epic space-opera media franchise created by George Lucas, which began with the eponymous 1977 film and quickly became a worldwide pop-culture phenomenon. The franchise has been expanded into various films and other media, including television series, video games, novels, comic books, theme park attractions, and themed areas, comprising an all-encompassing fictional universe.[b] The franchise holds a Guinness World Records title for the 'Most successful film merchandising franchise.' In 2020, the Star Wars franchise's total value was estimated at US$70 billion, and it is currently the fifth-highest-grossing media franchise of all time.")
        ]
    }
}
