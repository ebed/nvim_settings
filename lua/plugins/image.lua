return {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
        -- Usar kitty como backend predeterminado (más compatible con macOS)
        -- Opciones: "kitty", "sixel" - ueberzug no está disponible en macOS
        backend = "kitty",
        processor = "magick_cli",
        -- Añadir soporte para SVG en los patrones de archivo
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.svg" },
        -- Ajustes para mejorar visualización
        max_width_window_percentage = 95,
        max_height_window_percentage = 95,
        -- Configurar escala
        scale_factor = 1.0,
        -- Reducir uso de recursos
        editor_only_render_when_focused = true,
        -- Ignorar errores de descarga para archivos locales
        ignore_download_error = true
    }
}
