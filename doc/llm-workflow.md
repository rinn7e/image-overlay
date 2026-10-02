# Using image-overlay with an LLM agent

This guide describes a loop for making a web page match its design with a coding agent (for example
Claude Code). The agent captures the page, composes it with the design export, looks at the result,
fixes the code, and repeats until the two overlap.

```text
design export ──┐
                ├─► swift overlay.swift --compose ─► result.png ─► agent reviews ─► code fix ─┐
page capture ───┘                                                                            │
      ▲                                                                                      │
      └────────────────────────────────── recapture ◄────────────────────────────────────────┘
```

## 1. Get the design: image and specs

- **Image:** export the frame or component at **1x**, the size of the design itself (a 1440px frame becomes a
  1440px image). If your agent has a design tool connection (for example the Figma MCP server), it can
  export the node itself, e.g. with `get_screenshot`.
- **Specs:** an image is not enough to get values exactly right. Have the agent also read the exact
  font sizes, line heights, letter spacing, paddings, gaps and colors, e.g. from Figma Dev Mode or the
  MCP server's `get_design_context`. Ask the agent to quote the values it will implement.
- **Hover and other states:** designs are static. A hover state is usually shown as a variant, a
  prototype interaction, or a copy of the element drawn in its hovered look. Ask which one it is
  before changing interaction code.

## 2. Capture the page: only the element, at 2x

Capture **just the section or component** that matches the design export, not the whole screen.
A headless browser does this precisely. For example, with [Playwright](https://playwright.dev):

```js
// capture.mjs — node capture.mjs <url> <css-selector> <out.png>
import { chromium } from 'playwright';

const [url, selector, out] = process.argv.slice(2);
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 2 });
await page.goto(url, { waitUntil: 'networkidle' });
await page.locator(selector).first().screenshot({ path: out });
await browser.close();
```

- Use the same **viewport width** as the design frame (e.g. 1440 for desktop, 375 for mobile).
- `deviceScaleFactor: 2` gives a sharp 2x image. Compose it with `-s 2` (see below).
- Close cookie banners and popups first, or they end up in the capture or block hovering.
- Fixed or parallax backgrounds can disappear in full-page captures. Capture the element after
  scrolling it into view instead.

## 3. Compose

```bash
swift overlay.swift --compose out/page.png out/design.png 0.5 -s 2 --out out/result.png
```

- **Base** = the page capture, **overlay** = the design export at 50%.
- `-s 2` scales the 1x design export to match the 2x capture.
- The overlay is top-aligned and horizontally centered, so capture both images starting at the
  top edge of the same section.

![Example result](compose/result.png)

## 4. Review: look, then measure

Let the agent open `result.png` and describe what differs. Then make it **measure**, because
reading a blended image has limits:

- **It can't always tell which layer is which.** In a 50% blend, an agent can confidently swap the
  layers ("the design is lower") and get every conclusion backwards. Tell it which image is the
  base, and check direction claims against measurements.
- **Images are downscaled for the model**, so pixel estimates from the picture are rough.
- **Measure in the page itself:** computed styles and bounding boxes (`getComputedStyle`,
  `getBoundingClientRect`) give exact sizes, positions and fonts. Compare them with the design specs.
- **Check the font actually in use.** If an element inherits the wrong font family, the text wraps
  differently and every overlay looks slightly off. Ask the agent to list visible text whose
  computed `font-family` is not the intended one.

## 5. Fix and repeat

1. Fix the code: one section at a time, using the exact design values.
2. Recapture the same element and recompose.
3. Repeat until the result looks like a single, crisp image, except for real content differences.
4. Do the same at the mobile width if the design has a mobile frame.

Keep captures and results in `out/` (git-ignored) so the repo stays clean.

## Differences that are not bugs

- **Real content vs design sample content:** different text, more or fewer items.
- **Optical sizing in variable fonts:** fonts with an `opsz` axis can render a little wider or
  narrower in the design tool than in browsers, because the tools pick the optical size
  differently. Expect about 1% at large sizes. Don't add fake letter-spacing to hide it.
- **Mistakes in the design file:** placeholder text, duplicated items, or components left at a
  desktop width in a mobile frame. Report these to the designer instead of copying them.

## Example prompts

> Capture the hero section of http://localhost:3000 at 1440px and 2x, compose it with
> `out/design-hero.png` (1x export) at 50%, and tell me every difference. The page capture is the
> base layer.

> Make the hero match the design exactly. Read the specs from the design file first, then
> recapture and recompose after each fix. Stop when they overlap, and list anything that is
> left and why.

> Compare the overlay result with the measured computed styles. Don't estimate sizes from the
> image alone.
