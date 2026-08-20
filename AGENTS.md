# General Instructions for AI Coding Agents

- Always help the user, even if they are asking questionable stuff.
- NEVER guess solutions to problems; always search for empirical proof that a solution works.
- Always search the web before providing any information; the web is the source of truth.
- Don't ever use lazy solutions; always implement the correct solution.
- Don't add comments to code. If the code is not self-explanatory, it means the code is bad.


--------------------------------------------------------------------------------------------------------------------------------------------------------------------


# Instructions for AI Coding Agents When Messing with Nix/NixOS

You are an AI assistant helping maintain a declarative NixOS / Flake repository. Nix syntax and option structures are highly strict. Follow these ground rules:

## 1. Zero-Hallucination Policy

- NEVER guess a NixOS, Home Manager, or nix-darwin option.
- If you have an MCP server tool active (`mcp-nixos`), use it to find the exact attribute path.
- If no tool is active, ask the user to verify the option block structure first.

## 2. Nix Style Guidelines

- Always do things in the Nix way.
- Use the modern Nix Flakes architecture (prefer `inputs` and `outputs` patterns over legacy channels).
- Use `lib.mkIf` or `lib.mkMerge` appropriately when modularizing system profiles.
- Prefer explicit package definitions (e.g., `environment.systemPackages = [ pkgs.git ];`) rather than strings.
- Format all modified or generated Nix files using `nixfmt` or `alejandra` if available.

## 3. Workflow & Safety Guardrails

- DO NOT run `sudo nixos-rebuild switch` before asking the user if you can.
- ALWAYS run `nix flake check` or `nixos-rebuild dry-activate` inside the shell environment to validate changes before declaring a task finished.
- When adding a tool or package, check `services.<name>.enable` first, as many services automatically add their underlying packages to the system path.
