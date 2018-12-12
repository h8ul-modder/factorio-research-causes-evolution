script.on_init(
    function()
        game.map_settings.enemy_evolution.enabled = false
    end
)

script.on_event({defines.events.on_research_finished},
    function(event)
        local eventForce = event.research.force
        local currentReds = 0
        local totalReds = 0
        local equalTechValue = settings.global["research-causes-evolution-all-techs-equal"].value

        for techname, tech in pairs(eventForce.technologies) do
            if tech.research_unit_count_formula == nil and not tech.upgrade then -- not an infinite research and not an upgrade
                for _,ingredient in pairs(tech.research_unit_ingredients) do
                    if ingredient.name == "science-pack-1" then -- find the red research pack
                        local thisTechValue
                        if equalTechValue then
                            thisTechValue = totalReds + 1
                        else
                            thisTechValue = totalReds + ingredient.amount * tech.research_unit_count
                        end
                        totalReds = currentReds + thisTechValue
                        if tech.researched then
                            currentReds = currentReds + thisTechValue
                        end
                    end
                end
            end
        end
        for _,force in pairs(game.forces) do
            if force.ai_controllable then
                force.evolution_factor = currentReds / totalReds
            end
        end
    end
)