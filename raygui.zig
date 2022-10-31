const std = @import("std");
const raygui = @cImport({
    @cInclude("raygui.h");
    @cInclude("raygui_marshal.h");
});
const raylib = @import("../raylib/raylib.zig");

pub const Rectangle = raylib.Rectangle;
pub const Vector2 = raylib.Vector2;
pub const Color = raylib.Color;
pub const RICON_SIZE = 32;
pub const RICON_DATA_ELEMENTS = 255;

/// Load style from file (.rgs)
pub fn LoadGuiStyle(_: [*:0]const u8) u32 {
    // return raygui.LoadGuiStyle(fileName);
    return 0;
}

/// Unload style
pub fn UnloadGuiStyle(_: u32) void {
    // raygui.UnloadGuiStyle(style);
}

/// Text Box control with multiple lines
pub fn GuiTextBoxMulti(_: Rectangle, _: [*]u8, _: i32, _: bool) bool {
    @panic("this gets translated wrong with cImport");
}

/// List View with extended parameters
pub fn GuiListViewEx(
    _: Rectangle,
    _: [*]const [*:0]const u8,
    _: i32,
    _: [*]i32,
    _: [*]i32,
    _: i32,
) i32 {
    @panic("TODO: link with raygui somehow");
}

pub fn textAlignPixelOffset(h: i32) i32 {
    return h % 2;
}

fn bitCheck(a: u32, b: u32) bool {
    var r: u32 = undefined;
    _ = @shlWithOverflow(u32, 1, @truncate(u5, b), &r);
    return (a & (r)) != 0;
}

/// Draw selected icon using rectangles pixel-by-pixel
pub fn GuiDrawIcon(
    icon: raygui.GuiIconName,
    posX: i32,
    posY: i32,
    pixelSize: i32,
    color: raylib.Color,
) void {
    const iconId = @enumToInt(icon);

    var i: i32 = 0;
    var y: i32 = 0;
    while (i < RICON_SIZE * RICON_SIZE / 32) : (i += 1) {
        var k: u32 = 0;
        while (k < 32) : (k += 1) {
            if (bitCheck(raygui.guiIcons[@intCast(usize, iconId * RICON_DATA_ELEMENTS + i)], k)) {
                _ = raylib.DrawRectangle(
                    posX + @intCast(i32, k % RICON_SIZE) * pixelSize,
                    posY + y * pixelSize,
                    pixelSize,
                    pixelSize,
                    color,
                );
            }

            if ((k == 15) or (k == 31)) {
                y += 1;
            }
        }
    }
}

/// Draw button with icon centered
pub fn GuiDrawIconButton(bounds: raylib.Rectangle, icon: GuiIconName, iconTint: raylib.Color) bool {
    const pressed = GuiButton(bounds, "");
    GuiDrawIcon(
        icon,
        @floatToInt(i32, bounds.x + bounds.width / 2 - @intToFloat(f32, RICON_SIZE) / 2),
        @floatToInt(i32, bounds.y + (bounds.height / 2) - @intToFloat(f32, RICON_SIZE) / 2),
        1,
        iconTint,
    );
    return pressed;
}

/// Enable gui controls (global state)
pub fn GuiEnable() void {
    raygui.mGuiEnable();
}

/// Disable gui controls (global state)
pub fn GuiDisable() void {
    raygui.mGuiDisable();
}

/// Lock gui controls (global state)
pub fn GuiLock() void {
    raygui.mGuiLock();
}

/// Unlock gui controls (global state)
pub fn GuiUnlock() void {
    raygui.mGuiUnlock();
}

/// Check if gui is locked (global state)
pub fn GuiIsLocked() bool {
    return raygui.mGuiIsLocked();
}

/// Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
pub fn GuiFade(
    alpha: f32,
) void {
    raygui.mGuiFade(
        alpha,
    );
}

/// Set gui state (global state)
pub fn GuiSetState(
    state: i32,
) void {
    raygui.mGuiSetState(
        state,
    );
}

/// Get gui state (global state)
pub fn GuiGetState() i32 {
    return raygui.mGuiGetState();
}

/// Set gui custom font (global state)
pub fn GuiSetFont(
    font: Font,
) void {
    raygui.mGuiSetFont(
        @intToPtr([*c]raygui.Font, @ptrToInt(&font)),
    );
}

/// Get gui custom font (global state)
pub fn GuiGetFont() Font {
    var out: Font = undefined;
    raygui.mGuiGetFont(
        @ptrCast([*c]raygui.Font, &out),
    );
    return out;
}

/// Set one style property
pub fn GuiSetStyle(
    control: i32,
    property: i32,
    value: i32,
) void {
    raygui.mGuiSetStyle(
        control,
        property,
        value,
    );
}

/// Get one style property
pub fn GuiGetStyle(
    control: i32,
    property: i32,
) i32 {
    return raygui.mGuiGetStyle(
        control,
        property,
    );
}

/// Window Box control, shows a window that can be closed
pub fn GuiWindowBox(
    bounds: Rectangle,
    title: [*:0]const u8,
) bool {
    return raygui.mGuiWindowBox(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(title)),
    );
}

/// Group Box control with text name
pub fn GuiGroupBox(
    bounds: Rectangle,
    text: [*:0]const u8,
) void {
    raygui.mGuiGroupBox(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
    );
}

/// Line separator control, could contain text
pub fn GuiLine(
    bounds: Rectangle,
    text: [*:0]const u8,
) void {
    raygui.mGuiLine(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
    );
}

/// Panel control, useful to group controls
pub fn GuiPanel(
    bounds: Rectangle,
    text: [*:0]const u8,
) void {
    raygui.mGuiPanel(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
    );
}

/// Tab Bar control, returns TAB to be closed or -1
pub fn GuiTabBar(
    bounds: Rectangle,
    text: [*]const [*:0]const u8,
    count: i32,
    active: ?[*]i32,
) i32 {
    return raygui.mGuiTabBar(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const [*:0]const u8, @ptrToInt(text)),
        count,
        active,
    );
}

/// Scroll Panel control
pub fn GuiScrollPanel(
    bounds: Rectangle,
    text: [*:0]const u8,
    content: Rectangle,
    scroll: ?[*]Vector2,
) Rectangle {
    var out: Rectangle = undefined;
    raygui.mGuiScrollPanel(
        @ptrCast([*c]raygui.Rectangle, &out),
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&content)),
        scroll,
    );
    return out;
}

/// Label control, shows text
pub fn GuiLabel(
    bounds: Rectangle,
    text: [*:0]const u8,
) void {
    raygui.mGuiLabel(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
    );
}

/// Button control, returns true when clicked
pub fn GuiButton(
    bounds: Rectangle,
    text: [*:0]const u8,
) bool {
    return raygui.mGuiButton(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
    );
}

/// Label button control, show true when clicked
pub fn GuiLabelButton(
    bounds: Rectangle,
    text: [*:0]const u8,
) bool {
    return raygui.mGuiLabelButton(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
    );
}

/// Toggle Button control, returns true when active
pub fn GuiToggle(
    bounds: Rectangle,
    text: [*:0]const u8,
    active: bool,
) bool {
    return raygui.mGuiToggle(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        active,
    );
}

/// Toggle Group control, returns active toggle index
pub fn GuiToggleGroup(
    bounds: Rectangle,
    text: [*:0]const u8,
    active: i32,
) i32 {
    return raygui.mGuiToggleGroup(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        active,
    );
}

/// Check Box control, returns true when active
pub fn GuiCheckBox(
    bounds: Rectangle,
    text: [*:0]const u8,
    checked: bool,
) bool {
    return raygui.mGuiCheckBox(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        checked,
    );
}

/// Combo Box control, returns selected item index
pub fn GuiComboBox(
    bounds: Rectangle,
    text: [*:0]const u8,
    active: i32,
) i32 {
    return raygui.mGuiComboBox(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        active,
    );
}

/// Dropdown Box control, returns selected item
pub fn GuiDropdownBox(
    bounds: Rectangle,
    text: [*:0]const u8,
    active: ?[*]i32,
    editMode: bool,
) bool {
    return raygui.mGuiDropdownBox(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        active,
        editMode,
    );
}

/// Spinner control, returns selected value
pub fn GuiSpinner(
    bounds: Rectangle,
    text: [*:0]const u8,
    value: ?[*]i32,
    minValue: i32,
    maxValue: i32,
    editMode: bool,
) bool {
    return raygui.mGuiSpinner(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        value,
        minValue,
        maxValue,
        editMode,
    );
}

/// Value Box control, updates input text with numbers
pub fn GuiValueBox(
    bounds: Rectangle,
    text: [*:0]const u8,
    value: ?[*]i32,
    minValue: i32,
    maxValue: i32,
    editMode: bool,
) bool {
    return raygui.mGuiValueBox(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        value,
        minValue,
        maxValue,
        editMode,
    );
}

/// Text Box control, updates input text
pub fn GuiTextBox(
    bounds: Rectangle,
    text: ?[*]u8,
    textSize: i32,
    editMode: bool,
) bool {
    return raygui.mGuiTextBox(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        text,
        textSize,
        editMode,
    );
}

/// Slider control, returns selected value
pub fn GuiSlider(
    bounds: Rectangle,
    textLeft: [*:0]const u8,
    textRight: [*:0]const u8,
    value: f32,
    minValue: f32,
    maxValue: f32,
) f32 {
    return raygui.mGuiSlider(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(textLeft)),
        @intToPtr([*c]const u8, @ptrToInt(textRight)),
        value,
        minValue,
        maxValue,
    );
}

/// Slider Bar control, returns selected value
pub fn GuiSliderBar(
    bounds: Rectangle,
    textLeft: [*:0]const u8,
    textRight: [*:0]const u8,
    value: f32,
    minValue: f32,
    maxValue: f32,
) f32 {
    return raygui.mGuiSliderBar(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(textLeft)),
        @intToPtr([*c]const u8, @ptrToInt(textRight)),
        value,
        minValue,
        maxValue,
    );
}

/// Progress Bar control, shows current progress value
pub fn GuiProgressBar(
    bounds: Rectangle,
    textLeft: [*:0]const u8,
    textRight: [*:0]const u8,
    value: f32,
    minValue: f32,
    maxValue: f32,
) f32 {
    return raygui.mGuiProgressBar(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(textLeft)),
        @intToPtr([*c]const u8, @ptrToInt(textRight)),
        value,
        minValue,
        maxValue,
    );
}

/// Status Bar control, shows info text
pub fn GuiStatusBar(
    bounds: Rectangle,
    text: [*:0]const u8,
) void {
    raygui.mGuiStatusBar(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
    );
}

/// Dummy control for placeholders
pub fn GuiDummyRec(
    bounds: Rectangle,
    text: [*:0]const u8,
) void {
    raygui.mGuiDummyRec(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
    );
}

/// Grid control, returns mouse cell position
pub fn GuiGrid(
    bounds: Rectangle,
    text: [*:0]const u8,
    spacing: f32,
    subdivs: i32,
) Vector2 {
    var out: Vector2 = undefined;
    raygui.mGuiGrid(
        @ptrCast([*c]raygui.Vector2, &out),
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        spacing,
        subdivs,
    );
    return out;
}

/// List View control, returns selected list item index
pub fn GuiListView(
    bounds: Rectangle,
    text: [*:0]const u8,
    scrollIndex: ?[*]i32,
    active: i32,
) i32 {
    return raygui.mGuiListView(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        scrollIndex,
        active,
    );
}

/// Message Box control, displays a message
pub fn GuiMessageBox(
    bounds: Rectangle,
    title: [*:0]const u8,
    message: [*:0]const u8,
    buttons: [*:0]const u8,
) i32 {
    return raygui.mGuiMessageBox(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(title)),
        @intToPtr([*c]const u8, @ptrToInt(message)),
        @intToPtr([*c]const u8, @ptrToInt(buttons)),
    );
}

/// Text Input Box control, ask for text, supports secret
pub fn GuiTextInputBox(
    bounds: Rectangle,
    title: [*:0]const u8,
    message: [*:0]const u8,
    buttons: [*:0]const u8,
    text: ?[*]u8,
    textMaxSize: i32,
    secretViewActive: ?[*]i32,
) i32 {
    return raygui.mGuiTextInputBox(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(title)),
        @intToPtr([*c]const u8, @ptrToInt(message)),
        @intToPtr([*c]const u8, @ptrToInt(buttons)),
        text,
        textMaxSize,
        secretViewActive,
    );
}

/// Color Picker control (multiple color controls)
pub fn GuiColorPicker(
    bounds: Rectangle,
    text: [*:0]const u8,
    color: Color,
) Color {
    var out: Color = undefined;
    raygui.mGuiColorPicker(
        @ptrCast([*c]raygui.Color, &out),
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        @intToPtr([*c]raygui.Color, @ptrToInt(&color)),
    );
    return out;
}

/// Color Panel control
pub fn GuiColorPanel(
    bounds: Rectangle,
    text: [*:0]const u8,
    color: Color,
) Color {
    var out: Color = undefined;
    raygui.mGuiColorPanel(
        @ptrCast([*c]raygui.Color, &out),
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        @intToPtr([*c]raygui.Color, @ptrToInt(&color)),
    );
    return out;
}

/// Color Bar Alpha control
pub fn GuiColorBarAlpha(
    bounds: Rectangle,
    text: [*:0]const u8,
    alpha: f32,
) f32 {
    return raygui.mGuiColorBarAlpha(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        alpha,
    );
}

/// Color Bar Hue control
pub fn GuiColorBarHue(
    bounds: Rectangle,
    text: [*:0]const u8,
    value: f32,
) f32 {
    return raygui.mGuiColorBarHue(
        @intToPtr([*c]raygui.Rectangle, @ptrToInt(&bounds)),
        @intToPtr([*c]const u8, @ptrToInt(text)),
        value,
    );
}

/// Load style file over global style variable (.rgs)
pub fn GuiLoadStyle(
    fileName: [*:0]const u8,
) void {
    raygui.mGuiLoadStyle(
        @intToPtr([*c]const u8, @ptrToInt(fileName)),
    );
}

/// Load style default over global style
pub fn GuiLoadStyleDefault() void {
    raygui.mGuiLoadStyleDefault();
}

/// Get text with icon id prepended (if supported)
pub fn GuiIconText(
    iconId: i32,
    text: [*:0]const u8,
) [*:0]const u8 {
    return @ptrCast(
        [*:0]const u8,
        raygui.mGuiIconText(
            iconId,
            @intToPtr([*c]const u8, @ptrToInt(text)),
        ),
    );
}

/// Get raygui icons data pointer
pub fn GuiGetIcons() ?[*]u32 {
    var out: ?[*]u32 = undefined;
    raygui.mGuiGetIcons(
        @ptrCast([*c]?[*]u32, &out),
    );
    return out;
}

/// Load raygui icons file (.rgi) into internal icons data
pub fn GuiLoadIcons(
    fileName: [*:0]const u8,
    loadIconsName: bool,
) [*]const [*:0]u8 {
    return @ptrCast(
        [*][*:0]u8,
        raygui.mGuiLoadIcons(
            @intToPtr([*c]const u8, @ptrToInt(fileName)),
            loadIconsName,
        ),
    );
}

/// Vector3 type                 // -- ConvertHSVtoRGB(), ConvertRGBtoHSV()
pub const Vector3 = extern struct {
    ///
    x: f32,
    ///
    y: f32,
    ///
    z: f32,
};

/// It should be redesigned to be provided by user
pub const Texture2D = extern struct {
    /// OpenGL texture id
    id: u32,
    /// Texture base width
    width: i32,
    /// Texture base height
    height: i32,
    /// Mipmap levels, 1 by default
    mipmaps: i32,
    /// Data format (PixelFormat type)
    format: i32,
};

/// Image, pixel data stored in CPU memory (RAM)
pub const Image = extern struct {
    /// Image raw data
    data: *anyopaque,
    /// Image base width
    width: i32,
    /// Image base height
    height: i32,
    /// Mipmap levels, 1 by default
    mipmaps: i32,
    /// Data format (PixelFormat type)
    format: i32,
};

/// GlyphInfo, font characters glyphs info
pub const GlyphInfo = extern struct {
    /// Character value (Unicode)
    value: i32,
    /// Character offset X when drawing
    offsetX: i32,
    /// Character offset Y when drawing
    offsetY: i32,
    /// Character advance position X
    advanceX: i32,
    /// Character image data
    image: Image,
};

/// It should be redesigned to be provided by user
pub const Font = extern struct {
    /// Base size (default chars height)
    baseSize: i32,
    /// Number of glyph characters
    glyphCount: i32,
    /// Padding around the glyph characters
    glyphPadding: i32,
    /// Texture atlas containing the glyphs
    texture: Texture2D,
    /// Rectangles in texture for the glyphs
    recs: ?[*]Rectangle,
    /// Glyphs info data
    glyphs: ?[*]GlyphInfo,
};

/// Style property
pub const GuiStyleProp = extern struct {
    ///
    controlId: u16,
    ///
    propertyId: u16,
    ///
    propertyValue: u32,
};

/// Gui control state
pub const GuiState = enum(i32) {
    ///
    STATE_NORMAL = 0,
    ///
    STATE_FOCUSED = 1,
    ///
    STATE_PRESSED = 2,
    ///
    STATE_DISABLED = 3,
};

/// Gui control text alignment
pub const GuiTextAlignment = enum(i32) {
    ///
    TEXT_ALIGN_LEFT = 0,
    ///
    TEXT_ALIGN_CENTER = 1,
    ///
    TEXT_ALIGN_RIGHT = 2,
};

/// Gui controls
pub const GuiControl = enum(i32) {
    ///
    DEFAULT = 0,
    /// Used also for: LABELBUTTON
    LABEL = 1,
    ///
    BUTTON = 2,
    /// Used also for: TOGGLEGROUP
    TOGGLE = 3,
    /// Used also for: SLIDERBAR
    SLIDER = 4,
    ///
    PROGRESSBAR = 5,
    ///
    CHECKBOX = 6,
    ///
    COMBOBOX = 7,
    ///
    DROPDOWNBOX = 8,
    /// Used also for: TEXTBOXMULTI
    TEXTBOX = 9,
    ///
    VALUEBOX = 10,
    /// Uses: BUTTON, VALUEBOX
    SPINNER = 11,
    ///
    LISTVIEW = 12,
    ///
    COLORPICKER = 13,
    ///
    SCROLLBAR = 14,
    ///
    STATUSBAR = 15,
};

/// Gui base properties for every control
pub const GuiControlProperty = enum(i32) {
    ///
    BORDER_COLOR_NORMAL = 0,
    ///
    BASE_COLOR_NORMAL = 1,
    ///
    TEXT_COLOR_NORMAL = 2,
    ///
    BORDER_COLOR_FOCUSED = 3,
    ///
    BASE_COLOR_FOCUSED = 4,
    ///
    TEXT_COLOR_FOCUSED = 5,
    ///
    BORDER_COLOR_PRESSED = 6,
    ///
    BASE_COLOR_PRESSED = 7,
    ///
    TEXT_COLOR_PRESSED = 8,
    ///
    BORDER_COLOR_DISABLED = 9,
    ///
    BASE_COLOR_DISABLED = 10,
    ///
    TEXT_COLOR_DISABLED = 11,
    ///
    BORDER_WIDTH = 12,
    ///
    TEXT_PADDING = 13,
    ///
    TEXT_ALIGNMENT = 14,
    ///
    RESERVED = 15,
};

/// DEFAULT extended properties
pub const GuiDefaultProperty = enum(i32) {
    /// Text size (glyphs max height)
    TEXT_SIZE = 16,
    /// Text spacing between glyphs
    TEXT_SPACING = 17,
    /// Line control color
    LINE_COLOR = 18,
    /// Background color
    BACKGROUND_COLOR = 19,
};

/// Toggle/ToggleGroup
pub const GuiToggleProperty = enum(i32) {
    /// ToggleGroup separation between toggles
    GROUP_PADDING = 16,
};

/// Slider/SliderBar
pub const GuiSliderProperty = enum(i32) {
    /// Slider size of internal bar
    SLIDER_WIDTH = 16,
    /// Slider/SliderBar internal bar padding
    SLIDER_PADDING = 17,
};

/// ProgressBar
pub const GuiProgressBarProperty = enum(i32) {
    /// ProgressBar internal padding
    PROGRESS_PADDING = 16,
};

/// ScrollBar
pub const GuiScrollBarProperty = enum(i32) {
    ///
    ARROWS_SIZE = 16,
    ///
    ARROWS_VISIBLE = 17,
    /// (SLIDERBAR, SLIDER_PADDING)
    SCROLL_SLIDER_PADDING = 18,
    ///
    SCROLL_SLIDER_SIZE = 19,
    ///
    SCROLL_PADDING = 20,
    ///
    SCROLL_SPEED = 21,
};

/// CheckBox
pub const GuiCheckBoxProperty = enum(i32) {
    /// CheckBox internal check padding
    CHECK_PADDING = 16,
};

/// ComboBox
pub const GuiComboBoxProperty = enum(i32) {
    /// ComboBox right button width
    COMBO_BUTTON_WIDTH = 16,
    /// ComboBox button separation
    COMBO_BUTTON_SPACING = 17,
};

/// DropdownBox
pub const GuiDropdownBoxProperty = enum(i32) {
    /// DropdownBox arrow separation from border and items
    ARROW_PADDING = 16,
    /// DropdownBox items separation
    DROPDOWN_ITEMS_SPACING = 17,
};

/// TextBox/TextBoxMulti/ValueBox/Spinner
pub const GuiTextBoxProperty = enum(i32) {
    /// TextBox/TextBoxMulti/ValueBox/Spinner inner text padding
    TEXT_INNER_PADDING = 16,
    /// TextBoxMulti lines separation
    TEXT_LINES_SPACING = 17,
};

/// Spinner
pub const GuiSpinnerProperty = enum(i32) {
    /// Spinner left/right buttons width
    SPIN_BUTTON_WIDTH = 16,
    /// Spinner buttons separation
    SPIN_BUTTON_SPACING = 17,
};

/// ListView
pub const GuiListViewProperty = enum(i32) {
    /// ListView items height
    LIST_ITEMS_HEIGHT = 16,
    /// ListView items separation
    LIST_ITEMS_SPACING = 17,
    /// ListView scrollbar size (usually width)
    SCROLLBAR_WIDTH = 18,
    /// ListView scrollbar side (0-left, 1-right)
    SCROLLBAR_SIDE = 19,
};

/// ColorPicker
pub const GuiColorPickerProperty = enum(i32) {
    ///
    COLOR_SELECTOR_SIZE = 16,
    /// ColorPicker right hue bar width
    HUEBAR_WIDTH = 17,
    /// ColorPicker right hue bar separation from panel
    HUEBAR_PADDING = 18,
    /// ColorPicker right hue bar selector height
    HUEBAR_SELECTOR_HEIGHT = 19,
    /// ColorPicker right hue bar selector overflow
    HUEBAR_SELECTOR_OVERFLOW = 20,
};

///
pub const GuiIconName = enum(i32) {
    ///
    ICON_NONE = 0,
    ///
    ICON_FOLDER_FILE_OPEN = 1,
    ///
    ICON_FILE_SAVE_CLASSIC = 2,
    ///
    ICON_FOLDER_OPEN = 3,
    ///
    ICON_FOLDER_SAVE = 4,
    ///
    ICON_FILE_OPEN = 5,
    ///
    ICON_FILE_SAVE = 6,
    ///
    ICON_FILE_EXPORT = 7,
    ///
    ICON_FILE_ADD = 8,
    ///
    ICON_FILE_DELETE = 9,
    ///
    ICON_FILETYPE_TEXT = 10,
    ///
    ICON_FILETYPE_AUDIO = 11,
    ///
    ICON_FILETYPE_IMAGE = 12,
    ///
    ICON_FILETYPE_PLAY = 13,
    ///
    ICON_FILETYPE_VIDEO = 14,
    ///
    ICON_FILETYPE_INFO = 15,
    ///
    ICON_FILE_COPY = 16,
    ///
    ICON_FILE_CUT = 17,
    ///
    ICON_FILE_PASTE = 18,
    ///
    ICON_CURSOR_HAND = 19,
    ///
    ICON_CURSOR_POINTER = 20,
    ///
    ICON_CURSOR_CLASSIC = 21,
    ///
    ICON_PENCIL = 22,
    ///
    ICON_PENCIL_BIG = 23,
    ///
    ICON_BRUSH_CLASSIC = 24,
    ///
    ICON_BRUSH_PAINTER = 25,
    ///
    ICON_WATER_DROP = 26,
    ///
    ICON_COLOR_PICKER = 27,
    ///
    ICON_RUBBER = 28,
    ///
    ICON_COLOR_BUCKET = 29,
    ///
    ICON_TEXT_T = 30,
    ///
    ICON_TEXT_A = 31,
    ///
    ICON_SCALE = 32,
    ///
    ICON_RESIZE = 33,
    ///
    ICON_FILTER_POINT = 34,
    ///
    ICON_FILTER_BILINEAR = 35,
    ///
    ICON_CROP = 36,
    ///
    ICON_CROP_ALPHA = 37,
    ///
    ICON_SQUARE_TOGGLE = 38,
    ///
    ICON_SYMMETRY = 39,
    ///
    ICON_SYMMETRY_HORIZONTAL = 40,
    ///
    ICON_SYMMETRY_VERTICAL = 41,
    ///
    ICON_LENS = 42,
    ///
    ICON_LENS_BIG = 43,
    ///
    ICON_EYE_ON = 44,
    ///
    ICON_EYE_OFF = 45,
    ///
    ICON_FILTER_TOP = 46,
    ///
    ICON_FILTER = 47,
    ///
    ICON_TARGET_POINT = 48,
    ///
    ICON_TARGET_SMALL = 49,
    ///
    ICON_TARGET_BIG = 50,
    ///
    ICON_TARGET_MOVE = 51,
    ///
    ICON_CURSOR_MOVE = 52,
    ///
    ICON_CURSOR_SCALE = 53,
    ///
    ICON_CURSOR_SCALE_RIGHT = 54,
    ///
    ICON_CURSOR_SCALE_LEFT = 55,
    ///
    ICON_UNDO = 56,
    ///
    ICON_REDO = 57,
    ///
    ICON_REREDO = 58,
    ///
    ICON_MUTATE = 59,
    ///
    ICON_ROTATE = 60,
    ///
    ICON_REPEAT = 61,
    ///
    ICON_SHUFFLE = 62,
    ///
    ICON_EMPTYBOX = 63,
    ///
    ICON_TARGET = 64,
    ///
    ICON_TARGET_SMALL_FILL = 65,
    ///
    ICON_TARGET_BIG_FILL = 66,
    ///
    ICON_TARGET_MOVE_FILL = 67,
    ///
    ICON_CURSOR_MOVE_FILL = 68,
    ///
    ICON_CURSOR_SCALE_FILL = 69,
    ///
    ICON_CURSOR_SCALE_RIGHT_FILL = 70,
    ///
    ICON_CURSOR_SCALE_LEFT_FILL = 71,
    ///
    ICON_UNDO_FILL = 72,
    ///
    ICON_REDO_FILL = 73,
    ///
    ICON_REREDO_FILL = 74,
    ///
    ICON_MUTATE_FILL = 75,
    ///
    ICON_ROTATE_FILL = 76,
    ///
    ICON_REPEAT_FILL = 77,
    ///
    ICON_SHUFFLE_FILL = 78,
    ///
    ICON_EMPTYBOX_SMALL = 79,
    ///
    ICON_BOX = 80,
    ///
    ICON_BOX_TOP = 81,
    ///
    ICON_BOX_TOP_RIGHT = 82,
    ///
    ICON_BOX_RIGHT = 83,
    ///
    ICON_BOX_BOTTOM_RIGHT = 84,
    ///
    ICON_BOX_BOTTOM = 85,
    ///
    ICON_BOX_BOTTOM_LEFT = 86,
    ///
    ICON_BOX_LEFT = 87,
    ///
    ICON_BOX_TOP_LEFT = 88,
    ///
    ICON_BOX_CENTER = 89,
    ///
    ICON_BOX_CIRCLE_MASK = 90,
    ///
    ICON_POT = 91,
    ///
    ICON_ALPHA_MULTIPLY = 92,
    ///
    ICON_ALPHA_CLEAR = 93,
    ///
    ICON_DITHERING = 94,
    ///
    ICON_MIPMAPS = 95,
    ///
    ICON_BOX_GRID = 96,
    ///
    ICON_GRID = 97,
    ///
    ICON_BOX_CORNERS_SMALL = 98,
    ///
    ICON_BOX_CORNERS_BIG = 99,
    ///
    ICON_FOUR_BOXES = 100,
    ///
    ICON_GRID_FILL = 101,
    ///
    ICON_BOX_MULTISIZE = 102,
    ///
    ICON_ZOOM_SMALL = 103,
    ///
    ICON_ZOOM_MEDIUM = 104,
    ///
    ICON_ZOOM_BIG = 105,
    ///
    ICON_ZOOM_ALL = 106,
    ///
    ICON_ZOOM_CENTER = 107,
    ///
    ICON_BOX_DOTS_SMALL = 108,
    ///
    ICON_BOX_DOTS_BIG = 109,
    ///
    ICON_BOX_CONCENTRIC = 110,
    ///
    ICON_BOX_GRID_BIG = 111,
    ///
    ICON_OK_TICK = 112,
    ///
    ICON_CROSS = 113,
    ///
    ICON_ARROW_LEFT = 114,
    ///
    ICON_ARROW_RIGHT = 115,
    ///
    ICON_ARROW_DOWN = 116,
    ///
    ICON_ARROW_UP = 117,
    ///
    ICON_ARROW_LEFT_FILL = 118,
    ///
    ICON_ARROW_RIGHT_FILL = 119,
    ///
    ICON_ARROW_DOWN_FILL = 120,
    ///
    ICON_ARROW_UP_FILL = 121,
    ///
    ICON_AUDIO = 122,
    ///
    ICON_FX = 123,
    ///
    ICON_WAVE = 124,
    ///
    ICON_WAVE_SINUS = 125,
    ///
    ICON_WAVE_SQUARE = 126,
    ///
    ICON_WAVE_TRIANGULAR = 127,
    ///
    ICON_CROSS_SMALL = 128,
    ///
    ICON_PLAYER_PREVIOUS = 129,
    ///
    ICON_PLAYER_PLAY_BACK = 130,
    ///
    ICON_PLAYER_PLAY = 131,
    ///
    ICON_PLAYER_PAUSE = 132,
    ///
    ICON_PLAYER_STOP = 133,
    ///
    ICON_PLAYER_NEXT = 134,
    ///
    ICON_PLAYER_RECORD = 135,
    ///
    ICON_MAGNET = 136,
    ///
    ICON_LOCK_CLOSE = 137,
    ///
    ICON_LOCK_OPEN = 138,
    ///
    ICON_CLOCK = 139,
    ///
    ICON_TOOLS = 140,
    ///
    ICON_GEAR = 141,
    ///
    ICON_GEAR_BIG = 142,
    ///
    ICON_BIN = 143,
    ///
    ICON_HAND_POINTER = 144,
    ///
    ICON_LASER = 145,
    ///
    ICON_COIN = 146,
    ///
    ICON_EXPLOSION = 147,
    ///
    ICON_1UP = 148,
    ///
    ICON_PLAYER = 149,
    ///
    ICON_PLAYER_JUMP = 150,
    ///
    ICON_KEY = 151,
    ///
    ICON_DEMON = 152,
    ///
    ICON_TEXT_POPUP = 153,
    ///
    ICON_GEAR_EX = 154,
    ///
    ICON_CRACK = 155,
    ///
    ICON_CRACK_POINTS = 156,
    ///
    ICON_STAR = 157,
    ///
    ICON_DOOR = 158,
    ///
    ICON_EXIT = 159,
    ///
    ICON_MODE_2D = 160,
    ///
    ICON_MODE_3D = 161,
    ///
    ICON_CUBE = 162,
    ///
    ICON_CUBE_FACE_TOP = 163,
    ///
    ICON_CUBE_FACE_LEFT = 164,
    ///
    ICON_CUBE_FACE_FRONT = 165,
    ///
    ICON_CUBE_FACE_BOTTOM = 166,
    ///
    ICON_CUBE_FACE_RIGHT = 167,
    ///
    ICON_CUBE_FACE_BACK = 168,
    ///
    ICON_CAMERA = 169,
    ///
    ICON_SPECIAL = 170,
    ///
    ICON_LINK_NET = 171,
    ///
    ICON_LINK_BOXES = 172,
    ///
    ICON_LINK_MULTI = 173,
    ///
    ICON_LINK = 174,
    ///
    ICON_LINK_BROKE = 175,
    ///
    ICON_TEXT_NOTES = 176,
    ///
    ICON_NOTEBOOK = 177,
    ///
    ICON_SUITCASE = 178,
    ///
    ICON_SUITCASE_ZIP = 179,
    ///
    ICON_MAILBOX = 180,
    ///
    ICON_MONITOR = 181,
    ///
    ICON_PRINTER = 182,
    ///
    ICON_PHOTO_CAMERA = 183,
    ///
    ICON_PHOTO_CAMERA_FLASH = 184,
    ///
    ICON_HOUSE = 185,
    ///
    ICON_HEART = 186,
    ///
    ICON_CORNER = 187,
    ///
    ICON_VERTICAL_BARS = 188,
    ///
    ICON_VERTICAL_BARS_FILL = 189,
    ///
    ICON_LIFE_BARS = 190,
    ///
    ICON_INFO = 191,
    ///
    ICON_CROSSLINE = 192,
    ///
    ICON_HELP = 193,
    ///
    ICON_FILETYPE_ALPHA = 194,
    ///
    ICON_FILETYPE_HOME = 195,
    ///
    ICON_LAYERS_VISIBLE = 196,
    ///
    ICON_LAYERS = 197,
    ///
    ICON_WINDOW = 198,
    ///
    ICON_HIDPI = 199,
    ///
    ICON_FILETYPE_BINARY = 200,
    ///
    ICON_HEX = 201,
    ///
    ICON_SHIELD = 202,
    ///
    ICON_FILE_NEW = 203,
    ///
    ICON_FOLDER_ADD = 204,
    ///
    ICON_ALARM = 205,
    ///
    ICON_CPU = 206,
    ///
    ICON_ROM = 207,
    ///
    ICON_STEP_OVER = 208,
    ///
    ICON_STEP_INTO = 209,
    ///
    ICON_STEP_OUT = 210,
    ///
    ICON_RESTART = 211,
    ///
    ICON_BREAKPOINT_ON = 212,
    ///
    ICON_BREAKPOINT_OFF = 213,
    ///
    ICON_BURGER_MENU = 214,
    ///
    ICON_CASE_SENSITIVE = 215,
    ///
    ICON_REG_EXP = 216,
    ///
    ICON_FOLDER = 217,
    ///
    ICON_FILE = 218,
    ///
    ICON_219 = 219,
    ///
    ICON_220 = 220,
    ///
    ICON_221 = 221,
    ///
    ICON_222 = 222,
    ///
    ICON_223 = 223,
    ///
    ICON_224 = 224,
    ///
    ICON_225 = 225,
    ///
    ICON_226 = 226,
    ///
    ICON_227 = 227,
    ///
    ICON_228 = 228,
    ///
    ICON_229 = 229,
    ///
    ICON_230 = 230,
    ///
    ICON_231 = 231,
    ///
    ICON_232 = 232,
    ///
    ICON_233 = 233,
    ///
    ICON_234 = 234,
    ///
    ICON_235 = 235,
    ///
    ICON_236 = 236,
    ///
    ICON_237 = 237,
    ///
    ICON_238 = 238,
    ///
    ICON_239 = 239,
    ///
    ICON_240 = 240,
    ///
    ICON_241 = 241,
    ///
    ICON_242 = 242,
    ///
    ICON_243 = 243,
    ///
    ICON_244 = 244,
    ///
    ICON_245 = 245,
    ///
    ICON_246 = 246,
    ///
    ICON_247 = 247,
    ///
    ICON_248 = 248,
    ///
    ICON_249 = 249,
    ///
    ICON_250 = 250,
    ///
    ICON_251 = 251,
    ///
    ICON_252 = 252,
    ///
    ICON_253 = 253,
    ///
    ICON_254 = 254,
    ///
    ICON_255 = 255,
};

///
pub const RAYGUI_VERSION: []const u8 = "3.2";

///
pub const SCROLLBAR_LEFT_SIDE: i32 = 0;

///
pub const SCROLLBAR_RIGHT_SIDE: i32 = 1;

/// Size of icons in pixels (squared)
pub const RAYGUI_ICON_SIZE: i32 = 16;

/// Maximum number of icons
pub const RAYGUI_ICON_MAX_ICONS: i32 = 256;

/// Maximum length of icon name id
pub const RAYGUI_ICON_MAX_NAME_LENGTH: i32 = 32;

/// Maximum number of standard controls
pub const RAYGUI_MAX_CONTROLS: i32 = 16;

/// Maximum number of standard properties
pub const RAYGUI_MAX_PROPS_BASE: i32 = 16;

/// Maximum number of extended properties
pub const RAYGUI_MAX_PROPS_EXTENDED: i32 = 8;

///
pub const KEY_RIGHT: i32 = 262;

///
pub const KEY_LEFT: i32 = 263;

///
pub const KEY_DOWN: i32 = 264;

///
pub const KEY_UP: i32 = 265;

///
pub const KEY_BACKSPACE: i32 = 259;

///
pub const KEY_ENTER: i32 = 257;

///
pub const MOUSE_LEFT_BUTTON: i32 = 0;

///
pub const RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT: i32 = 24;

///
pub const RAYGUI_GROUPBOX_LINE_THICK: i32 = 1;

///
pub const RAYGUI_LINE_MARGIN_TEXT: i32 = 12;

///
pub const RAYGUI_LINE_TEXT_PADDING: i32 = 4;

///
pub const RAYGUI_PANEL_BORDER_WIDTH: i32 = 1;

///
pub const RAYGUI_TABBAR_ITEM_WIDTH: i32 = 160;

///
pub const RAYGUI_TOGGLEGROUP_MAX_ITEMS: i32 = 32;

///
pub const RAYGUI_VALUEBOX_MAX_CHARS: i32 = 32;

///
pub const RAYGUI_COLORBARALPHA_CHECKED_SIZE: i32 = 10;

///
pub const RAYGUI_MESSAGEBOX_BUTTON_HEIGHT: i32 = 24;

///
pub const RAYGUI_MESSAGEBOX_BUTTON_PADDING: i32 = 12;

///
pub const RAYGUI_TEXTINPUTBOX_BUTTON_HEIGHT: i32 = 24;

///
pub const RAYGUI_TEXTINPUTBOX_BUTTON_PADDING: i32 = 12;

///
pub const RAYGUI_TEXTINPUTBOX_HEIGHT: i32 = 26;

///
pub const RAYGUI_GRID_ALPHA: f32 = 0.15000000596046448;

///
pub const MAX_LINE_BUFFER_SIZE: i32 = 256;

///
pub const ICON_TEXT_PADDING: i32 = 4;

///
pub const RAYGUI_MAX_TEXT_LINES: i32 = 128;

///
pub const RAYGUI_TEXTSPLIT_MAX_ITEMS: i32 = 128;

///
pub const RAYGUI_TEXTSPLIT_MAX_TEXT_SIZE: i32 = 1024;

///
pub const RAYGUI_TEXTFORMAT_MAX_SIZE: i32 = 256;