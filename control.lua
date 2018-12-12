--[[
   Copyright 2018 admo/H8UL

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
--]]

local function onInit()
    game.map_settings.enemy_evolution.enabled = false
end

local function onReseearchFinished(event)
    local eventForce = event.research.force
    local currentReds = 0
    local totalReds = 0
    local equalTechValue = settings.global["research-causes-evolution-all-techs-equal"].value

    for _, tech in pairs(eventForce.technologies) do
        if tech.research_unit_count_formula == nil and not tech.upgrade then -- not an infinite research and not an upgrade
            for _,ingredient in pairs(tech.research_unit_ingredients) do
                if ingredient.name == "science-pack-1" then -- find the red research pack

                    local thisTechReds
                    if equalTechValue then
                        thisTechReds = 1
                    else
                        thisTechReds = ingredient.amount * tech.research_unit_count
                    end

                    if tech.researched then
                        currentReds = currentReds + thisTechReds
                    end
                    totalReds = totalReds + thisTechReds
                end
            end
        end
        for _,force in pairs(game.forces) do
            if force.ai_controllable then
                force.evolution_factor = currentReds / totalReds
            end
        end
    end
end

script.on_event({defines.events.on_research_finished}, onReseearchFinished)
script.on_init(onInit)