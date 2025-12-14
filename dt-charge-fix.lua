local ffi = require("ffi")

local patch_size = 29
local mem_buffer = ffi.new("char[?]", patch_size)
local mem_original = ffi.new("char[?]", patch_size)
local mem_address = ffi.cast("char*", 0x433AC04B)

-- Делаем копию оригинала и готовим патч
ffi.copy(mem_original, mem_address, patch_size)
ffi.copy(mem_buffer, mem_original, patch_size)

for i = 0, 23 do
    mem_buffer[i] = 0x90
end
mem_buffer[24] = 0xE9

-- Элемент интерфейса
local ui_switch = ui.new_checkbox("RAGE", "Other", "Unsafe Charge")

-- Обработчик
ui.set_callback(ui_switch, function()
    if ui.get(ui_switch) then
        ffi.copy(mem_address, mem_buffer, patch_size)
    else
        ffi.copy(mem_address, mem_original, patch_size)
    end
end)

-- Восстановление при выгрузке
client.set_event_callback("shutdown", function()
    if ui.get(ui_switch) then
        ffi.copy(mem_address, mem_original, patch_size)
    end
end)