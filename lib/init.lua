-- typescript-resource-pulsar-library main module.
-- Renders pulsar-client producer plugin:
--   src/plugins/messaging.ts
--
-- The calling archetype is responsible for adding the corresponding
-- pnpm dependency to package.json:
--   pulsar-client
--
-- API:
--   local pulsar = require("typescript-resource-pulsar")
--   pulsar.render(context, { destination = context:get("project-name") })
--
-- Context contract (prompt() fills if absent):
--   prefix-name  — kebab-case first segment (e.g. "billing")
--   suffix-name  — kebab-case second segment (e.g. "service")

local M = {}

function M.prompt(context)
    if not context:get("prefix-name") then
        context:prompt_text("Service Prefix:", "prefix_name", {
            cases = Cases.programming(),
            placeholder = "billing",
        })
    end
    if not context:get("suffix-name") then
        context:prompt_text("Service Suffix:", "suffix_name", {
            cases = Cases.programming(),
            placeholder = "service",
            default = "service",
        })
    end
    if not context:get("project-name") then
        context:set("project-name", context:get("prefix-name") .. "-" .. context:get("suffix-name"))
    end
    return context
end

function M.render(context, opts)
    opts = opts or {}
    local d = opts.destination
    if d and d ~= "" then
        directory.render("contents", context, { destination = d })
    else
        directory.render("contents", context)
    end
    return context
end

function M.run(context, opts)
    M.prompt(context, opts)
    M.render(context, opts)
    return context
end

return M
