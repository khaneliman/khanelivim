# Snacks Image Module Test File

This file tests the various image rendering capabilities of the snacks.nvim
image module.

## Math Expressions

### Inline Math

The quadratic formula is $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$ and Einstein's
famous equation is $E = mc^2$.

### Block Math

Here's the Pythagorean theorem:

$$
a^2 + b^2 = c^2
$$

Some calculus:

$$
\int_{a}^{b} f(x) \, dx = F(b) - F(a)
$$

Matrix example:

# $$ \begin{pmatrix} a & b \\ c & d \end{pmatrix} \begin{pmatrix} x \\ y \end{pmatrix}

\begin{pmatrix} ax + by \\ cx + dy \end{pmatrix} $$

### Advanced Math

Summation notation:

$$
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
$$

Limits:

$$
\lim_{x \to \infty} \frac{1}{x} = 0
$$

Greek letters and symbols:

$$
\alpha, \beta, \gamma, \Delta, \Sigma, \Omega
$$

## Mermaid Diagrams

### Flowchart

```mermaid
flowchart TD
    A[Start] --> B{Is it working?}
    B -->|Yes| C[Great!]
    B -->|No| D[Debug]
    D --> E[Check logs]
    E --> F[Fix issue]
    F --> B
    C --> G[End]
```

### Sequence Diagram

```mermaid
sequenceDiagram
    participant User
    participant Neovim
    participant Snacks
    participant Terminal

    User->>Neovim: Open image file
    Neovim->>Snacks: Process image
    Snacks->>Terminal: Send via Kitty protocol
    Terminal-->>User: Display image

    User->>Neovim: Open markdown with math
    Neovim->>Snacks: Render LaTeX
    Snacks->>Terminal: Send rendered image
    Terminal-->>User: Display math
```

### Git Graph

```mermaid
gitGraph
    commit
    commit
    branch develop
    checkout develop
    commit
    commit
    checkout main
    merge develop
    commit
```

### Class Diagram

```mermaid
classDiagram
    class Image {
        +String path
        +Number width
        +Number height
        +render()
        +resize()
    }

    class Math {
        +String latex
        +String typst
        +render()
    }

    class Mermaid {
        +String diagram
        +String theme
        +render()
    }

    Image <|-- Math
    Image <|-- Mermaid
```

### State Diagram

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Loading: Open file
    Loading --> Rendering: Convert
    Rendering --> Displayed: Success
    Displayed --> Idle: Close
    Rendering --> Error: Failure
    Error --> Idle: Retry
```

## Sample Images (from URLs)

### PNG Image

![Neovim Logo](https://raw.githubusercontent.com/neovim/neovim.github.io/master/logos/neovim-logo-600x173.png)

### SVG Image

![Nix Logo](https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg)

### GitHub User Avatar

![Folke Avatar](https://avatars.githubusercontent.com/u/292349?v=4)

## Testing Instructions

1. Open this file in Neovim with snacks.nvim configured
2. Math expressions should render automatically
3. Mermaid diagrams should render as images
4. URL images should be fetched and displayed inline
5. Use `:checkhealth snacks` to verify image support

## Keybindings to Test

- Position cursor over an image/math expression
- Run `:lua Snacks.image.hover()` to view in floating window
- Images should automatically render inline in Kitty terminal

## Expected Behavior

- **Math**: Should render as typeset equations
- **Mermaid**: Should render as diagrams with dark theme
- **Images**: Should display inline or in floating window
- **Performance**: Should be smooth with caching enabled
