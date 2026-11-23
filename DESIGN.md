---
name: DroneBridge DLSE Commercial Support Suite
description: Desktop interface for discovering and managing DLSE devices.
colors:
  background: "#081624"
  panel: "#0a1c2e"
  raised: "#12304d"
  hover: "#0c2136"
  accent: "#ff8e00"
  success: "#34d399"
  warning: "#ffa00a"
  error: "#ffaeae"
  primary-text: "#e2d5c8"
  secondary-text: "#deceb9"
  link: "#d0edff"
  border: "#2e3a47"
typography:
  body:
    fontFamily: "Geist"
    fontSize: "14px"
  small:
    fontFamily: "Geist"
    fontSize: "12px"
  heading:
    fontFamily: "Geist"
    fontSize: "18px"
  data:
    fontFamily: "Geist Mono"
    fontSize: "12px"
rounded:
  badge: "4px"
  control: "5px"
  dialog: "6px"
components:
  button:
    backgroundColor: "{colors.raised}"
    textColor: "{colors.primary-text}"
    rounded: "{rounded.control}"
    height: "34px"
  input:
    backgroundColor: "{colors.panel}"
    textColor: "{colors.primary-text}"
    rounded: "{rounded.control}"
  tooltip:
    backgroundColor: "{colors.raised}"
    textColor: "{colors.primary-text}"
    rounded: "{rounded.control}"
---

# Design System: DroneBridge DLSE Commercial Support Suite

## Overview

The application is a dense desktop operations tool. Dark blue surfaces, warm light text, and orange emphasis support fleet monitoring and device-management workflows. This document describes the existing Qt Quick implementation; `ui/qml/Theme.qml` and the component files are the source of truth when implementation and this reference differ. Update this document when shared choices change.

## Colors

The shared palette is declared in `Theme.qml` and recorded in the frontmatter. Background, panel, raised, and hover colors distinguish surfaces. Accent orange marks emphasis and focus; success, warning, and error colors communicate status. Primary and secondary text establish hierarchy, and borders separate controls and panels. `mutedText` is the translucent Qt color `#87deceb9`; preserve Qt's alpha-first notation when editing QML.

Status badges also use component-specific dark green, amber, red, and neutral backgrounds in `StatusBadge.qml`. The offline footer count uses success for zero and accent for a nonzero count. Color accompanies status text rather than replacing it.

## Typography

Use Geist for UI labels, controls, and headings, and Geist Mono for fleet data, badges, and footer values. `Theme.qml` defines 12 px small text, 14 px body text, and 18 px headings; it also defines icon glyph sizes. Bundled fonts are loaded by `ui/app.py`. Buttons and headings commonly use bold text. Preserve technical abbreviations in fleet headers.

## Layout

The main window starts at 1298 × 804 and has a minimum size of 1180 × 720. Fleet Manager uses a table or matrix beside a resizable inspector; the table supports horizontal and vertical scrolling and configurable, resizable columns. Align column headers with their content: text left, numeric values right, and status badges and checkboxes centered. Keep SYS ID warning badges aligned with their numeric columns. Operation labels and progress share a column.

The footer groups fleet counts and activity on the left and service statuses on the right, with a flexible spacer between them. The offline count covers the retained fleet, including filtered-out devices. Footer items can shrink at narrow widths. Layouts use local spacing rather than a documented global spacing scale.

## Elevation & Depth

The shared controls and dialogs use flat, layered surfaces and borders rather than a shared shadow system. Background, panel, raised and hover colors communicate separation and interaction.

## Shapes

Controls and tooltips typically use 5 px rounded corners, badges 4 px, and modal dialogs 6 px. Borders are generally 1 px; focused or hovered controls use the accent where their component specifies it.

## Components

- **Buttons — `AppButton.qml`:** 34 px default height, minimum width 96 px; supports emphasized and quiet variants, icons, busy state, keyboard focus, hover, pressed, and disabled states. Use its properties instead of duplicating the styling.
- **Checkboxes — `AppCheckBox.qml`:** 17 px indicator with orange checked and focused states; label and disabled colors come from the theme.
- **Text fields — `AppTextField.qml`:** panel background, themed text and placeholder, orange selection and focus border. Horizontal padding is 10 px.
- **Combo boxes — `AppComboBox.qml`:** 34 px control with themed popup, highlighted option and focus border. `SerialComboBox.qml` specializes its indicator.
- **Dialogs — `ModalDialog.qml`:** modal panel with border, 18 px body padding, 48 px title header, optional close control, and Escape dismissal when dismissible. Width is constrained by the parent.
- **Tooltips — `SettingToolTip.qml` and `SettingTooltipLabel.qml`:** shared raised surface, border and wrapped themed text. Settings labels use a 500 ms hover delay. Anchor tooltips to their control and place them where they remain visible; the footer tooltip opens above its anchor.
- **Status badges — `StatusBadge.qml`:** uppercase monospace labels, 22 px high, with colors for success, waiting, failure and critical states.
- **Fleet table and footer — `MainScreen.qml`:** reusable theme tokens and shared controls support selection, sorting, resizing, status badges, progress and grouped status indicators.

## Do's and Don'ts

- Do reuse `Theme.qml` and existing shared controls for new UI.
- Do retain readable labels alongside colors and status indicators.
- Do preserve keyboard focus and disabled states when extending controls.
- Do keep operational data legible and table alignment consistent across headers and cells.
- Don't duplicate tooltip or control styling where an existing component fits.
