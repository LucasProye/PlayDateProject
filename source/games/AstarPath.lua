class("AstarPath").extends()

function AstarPath:init(success, nodes)
    self.nodes = nodes
    self.success = success
end