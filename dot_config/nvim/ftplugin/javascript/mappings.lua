local package_info = require('package-info')

require("which-key").register({
    ["<leader>n"] = {
        name = "package info",
        s = { package_info.show, "Show dependency versions", buffer = 0 },
        c = { package_info.hide, "Hide dependency versions", buffer = 0 },
        u = { package_info.update, "Update dependency versions", buffer = 0 },
        d = { package_info.delete, "Delete dependency on line", buffer = 0 },
        i = { package_info.install, "Install dependency", buffer = 0 },
        p = { package_info.change_version, "Install different dependency version", buffer = 0 },
    }
})
