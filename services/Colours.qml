pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config

QtObject {
    id: root

    readonly property bool light: false

    readonly property M3Palette palette: M3Palette {}
    readonly property M3TPalette tPalette: M3TPalette {}

    readonly property Transparency transparency: Transparency {}

    function layer(c: color, layer: var): color {
        if (!transparency.enabled)
            return c;

        return layer === 0 ? Qt.alpha(c, transparency.base) : alterColour(c, transparency.layers, layer ?? 1);
    }

    function alterColour(c: color, alpha: real, layer: int): color {
        const luminance = Math.sqrt(
            0.299 * c.r * c.r +
            0.587 * c.g * c.g +
            0.114 * c.b * c.b
        );

        if (luminance <= 0)
            return Qt.rgba(c.r, c.g, c.b, alpha);

        const direction = root.light ? -1 : 1;

        const scale =
            (luminance +
             direction * layer *
             0.3 * (1 - transparency.base)) /
            luminance;

        return Qt.rgba(
            Math.max(0, Math.min(1, c.r * scale)),
            Math.max(0, Math.min(1, c.g * scale)),
            Math.max(0, Math.min(1, c.b * scale)),
            alpha
        );
    }

    function on(c: color): color {
        return root.light
            ? Qt.lighter(c)
            : Qt.darker(c);
    }

    component Transparency: QtObject {
        readonly property bool enabled: true

        readonly property real base:
            Math.max(0, Math.min(1, Tokens.transparency.base))

        readonly property real layers:
            Math.max(0, Math.min(1, Tokens.transparency.layers))
    }

    component M3TPalette: QtObject {
        readonly property color m3primary:
            root.palette.m3primary
        readonly property color m3onPrimary:
            root.palette.m3onPrimary
        readonly property color m3primaryContainer:
            root.palette.m3primaryContainer
        readonly property color m3onPrimaryContainer:
            root.palette.m3onPrimaryContainer

        readonly property color m3secondary:
            root.palette.m3secondary
        readonly property color m3onSecondary:
            root.palette.m3onSecondary
        readonly property color m3secondaryContainer:
            root.palette.m3secondaryContainer
        readonly property color m3onSecondaryContainer:
            root.palette.m3onSecondaryContainer

        readonly property color m3tertiary:
            root.palette.m3tertiary
        readonly property color m3onTertiary:
            root.palette.m3onTertiary
        readonly property color m3tertiaryContainer:
            root.palette.m3tertiaryContainer
        readonly property color m3onTertiaryContainer:
            root.palette.m3onTertiaryContainer

        readonly property color m3background:
            root.palette.m3background
        readonly property color m3onBackground:
            root.palette.m3onBackground

        readonly property color m3surface:
            root.palette.m3surface
        readonly property color m3surfaceDim:
            root.palette.m3surfaceDim
        readonly property color m3surfaceBright:
            root.palette.m3surfaceBright

        readonly property color m3surfaceContainerLowest:
            root.palette.m3surfaceContainerLowest
        readonly property color m3surfaceContainerLow:
            root.palette.m3surfaceContainerLow
        readonly property color m3surfaceContainer:
            root.palette.m3surfaceContainer
        readonly property color m3surfaceContainerHigh:
            root.palette.m3surfaceContainerHigh
        readonly property color m3surfaceContainerHighest:
            root.palette.m3surfaceContainerHighest

        readonly property color m3onSurface:
            root.palette.m3onSurface
        readonly property color m3surfaceVariant:
            root.palette.m3surfaceVariant
        readonly property color m3onSurfaceVariant:
            root.palette.m3onSurfaceVariant

        readonly property color m3inverseSurface:
            root.palette.m3inverseSurface
        readonly property color m3inverseOnSurface:
            root.palette.m3inverseOnSurface
        readonly property color m3inversePrimary:
            root.palette.m3inversePrimary
        readonly property color m3outline:
            root.palette.m3outline
        readonly property color m3outlineVariant:
            root.palette.m3outlineVariant
        readonly property color m3shadow:
            root.palette.m3shadow
        readonly property color m3scrim:
            root.palette.m3scrim
        readonly property color m3surfaceTint:
            root.palette.m3surfaceTint

        readonly property color m3error:
            root.palette.m3error
        readonly property color m3onError:
            root.palette.m3onError
        readonly property color m3errorContainer:
            root.palette.m3errorContainer
        readonly property color m3onErrorContainer:
            root.palette.m3onErrorContainer

        readonly property color m3success:
            root.palette.m3success
        readonly property color m3onSuccess:
            root.palette.m3onSuccess
        readonly property color m3successContainer:
            root.palette.m3successContainer
        readonly property color m3onSuccessContainer:
            root.palette.m3onSuccessContainer

        readonly property color m3primaryFixed:
            root.palette.m3primaryFixed
        readonly property color m3primaryFixedDim:
            root.palette.m3primaryFixedDim
        readonly property color m3onPrimaryFixed:
            root.palette.m3onPrimaryFixed
        readonly property color m3onPrimaryFixedVariant:
            root.palette.m3onPrimaryFixedVariant

        readonly property color m3secondaryFixed:
            root.palette.m3secondaryFixed
        readonly property color m3secondaryFixedDim:
            root.palette.m3secondaryFixedDim
        readonly property color m3onSecondaryFixed:
            root.palette.m3onSecondaryFixed
        readonly property color m3onSecondaryFixedVariant:
            root.palette.m3onSecondaryFixedVariant

        readonly property color m3tertiaryFixed:
            root.palette.m3tertiaryFixed
        readonly property color m3tertiaryFixedDim:
            root.palette.m3tertiaryFixedDim
        readonly property color m3onTertiaryFixed:
            root.palette.m3onTertiaryFixed
        readonly property color m3onTertiaryFixedVariant:
            root.palette.m3onTertiaryFixedVariant
    }

    component M3Palette: QtObject {
        // Palette key colours
        property color m3primary_paletteKeyColor: "#a8627b"
        property color m3secondary_paletteKeyColor: "#8e6f78"
        property color m3tertiary_paletteKeyColor: "#986e4c"
        property color m3neutral_paletteKeyColor: "#807477"
        property color m3neutral_variant_paletteKeyColor: "#837377"

        // Background
        property color m3background: "#191114"
        property color m3onBackground: "#efdfe2"

        // Surface
        property color m3surface: "#191114"
        property color m3surfaceDim: "#191114"
        property color m3surfaceBright: "#403739"

        property color m3surfaceContainerLowest: "#130c0e"
        property color m3surfaceContainerLow: "#22191c"
        property color m3surfaceContainer: "#261d20"
        property color m3surfaceContainerHigh: "#31282a"
        property color m3surfaceContainerHighest: "#3c3235"

        property color m3onSurface: "#efdfe2"
        property color m3surfaceVariant: "#514347"
        property color m3onSurfaceVariant: "#d5c2c6"

        property color m3inverseSurface: "#efdfe2"
        property color m3inverseOnSurface: "#372e30"

        property color m3outline: "#9e8c91"
        property color m3outlineVariant: "#514347"
        property color m3shadow: "#000000"
        property color m3scrim: "#000000"
        property color m3surfaceTint: "#ffb0ca"

        // Primary
        property color m3primary: "#ffb0ca"
        property color m3onPrimary: "#541d34"
        property color m3primaryContainer: "#6f334a"
        property color m3onPrimaryContainer: "#ffd9e3"
        property color m3inversePrimary: "#8b4a62"

        // Secondary
        property color m3secondary: "#e2bdc7"
        property color m3onSecondary: "#422932"
        property color m3secondaryContainer: "#5a3f48"
        property color m3onSecondaryContainer: "#ffd9e3"

        // Tertiary
        property color m3tertiary: "#f0bc95"
        property color m3onTertiary: "#48290c"
        property color m3tertiaryContainer: "#b58763"
        property color m3onTertiaryContainer: "#000000"

        // Error
        property color m3error: "#ffb4ab"
        property color m3onError: "#690005"
        property color m3errorContainer: "#93000a"
        property color m3onErrorContainer: "#ffdad6"

        // Success
        property color m3success: "#B5CCBA"
        property color m3onSuccess: "#213528"
        property color m3successContainer: "#374B3E"
        property color m3onSuccessContainer: "#D1E9D6"

        // Fixed
        property color m3primaryFixed: "#ffd9e3"
        property color m3primaryFixedDim: "#ffb0ca"
        property color m3onPrimaryFixed: "#39071f"
        property color m3onPrimaryFixedVariant: "#6f334a"

        property color m3secondaryFixed: "#ffd9e3"
        property color m3secondaryFixedDim: "#e2bdc7"
        property color m3onSecondaryFixed: "#2b151d"
        property color m3onSecondaryFixedVariant: "#5a3f48"

        property color m3tertiaryFixed: "#ffdcc3"
        property color m3tertiaryFixedDim: "#f0bc95"
        property color m3onTertiaryFixed: "#2f1500"
        property color m3onTertiaryFixedVariant: "#623f21"

        // Terminal
        property color term0: "#353434"
        property color term1: "#ff4c8a"
        property color term2: "#ffbbb7"
        property color term3: "#ffdedf"
        property color term4: "#b3a2d5"
        property color term5: "#e98fb0"
        property color term6: "#ffba93"
        property color term7: "#eed1d2"
        property color term8: "#b39e9e"
        property color term9: "#ff80a3"
        property color term10: "#ffd3d0"
        property color term11: "#fff1f0"
        property color term12: "#dcbc93"
        property color term13: "#f9a8c2"
        property color term14: "#ffd1c0"
        property color term15: "#ffffff"
    }
}