{ inputs }: { config, pkgs, lib, ... }:

let
  fromGitHub = rev: ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };
in
{
  home.username = "fcoury";
  home.homeDirectory = "/home/fcoury";
  home.packages = with pkgs; [
    neofetch
    nnn
    fish

    # archives
    zip
    unzip

    # utils
    ripgrep
    jq
    eza
    fzf

    # networking tools
    dnsutils
    ldns
    aria2
    nmap

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    nix-output-monitor

    # productivity
    btop
    iotop
    iftop

    strace
    ltrace
    lsof

    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # dev
    nerdfonts
    vscode
    nodejs
    yarn
    gcc
    gnumake
    glibc.dev
    binutils
    autoconf
    automake
    libtool
    pkg-config
    rustup

    # apps
    google-chrome
  ];

  programs.fish = {
    enable = true;
    shellInit = ''
    # searches home and home/code folders by default
    set -g CDPATH . $HOME $HOME/code

    # general functions
    function ca
      cargo add $argv; and cargo sort
    end

    function mc
      set dir $argv[1]
      if test -z "$argv[1]"
        set dir (pwd)
      end

      set prev_dir (pwd)

      function onexit --on-signal SIGINT --on-signal SIGTERM
        cd $prev_dir
      end

      cd $HOME/code/msuite
      cargo run -- -d config --env-file "$dir/.env" --path "$dir" --watch

      cd $prev_dir
    end

    function tt
      set dir (pwd)
      set test $argv[1]
      if test -z "$argv[1]"
        set test "."
      end

      set prev_dir (pwd)

      function onexit --on-signal SIGINT --on-signal SIGTERM
        cd $prev_dir
      end

      cd $HOME/code/msuite
      cargo watch -x 'run -- config --path '"$dir"' --env-file '"$dir/.env"' test '"$dir/$argv"' --watch'

      cd $prev_dir
    end

    # Eza config
    # Remove alias or function named 'ls' if it exists
    functions -e ls

    # Check if 'eza' command exists
    if type -q eza
        # Define the 'ls' function
        function ls
            # Check if '-rt' is in the arguments
            set contains_rt false
            for arg in $argv
                if test "$arg" = "-rt"
                    set contains_rt true
                    break
                end
            end

            # Replace '-rt' with '-snew' if present
            if test $contains_rt = true
                set new_argv (string replace -- '-rt' '-snew' $argv)
                eza $new_argv
            else
                eza $argv
            end
        end
    end

    '';
    interactiveShellInit = ''
      set -U fish_greeting # Disable greeting
    '';
    shellAliases = {
      gl = "git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      gap = "git add -p";
    };
  };

  programs.git = {
    enable = true;
    userName = "Felipe Coury";
    userEmail = "felipe.coury@gmail.com";
    aliases = {
      co = "checkout";
      st = "status -sb";
      ap = "add -p";
    };
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars

      # telescope
      plenary-nvim
      telescope-nvim
      telescope-ui-select-nvim

      # cmp
      nvim-cmp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      lspkind-nvim
      cmp-nvim-lsp
      cmp-cmdline

      # copilot
      copilot-lua
      copilot-cmp

      comment-nvim
      legendary-nvim
      lualine-nvim
      nvim-tree-lua
      vim-visual-multi
      todo-comments-nvim
      rust-tools-nvim
      vim-cool
      fidget-nvim
      legendary-nvim
      indent-blankline-nvim

      (fromGitHub "e7868b38f402be94e859d479002df1418bc1e954" "main" "coffebar/neovim-project")
      (fromGitHub "68dde355a4304d83b40cf073f53915604bdd8e70" "master" "Shatur/neovim-session-manager")

      # configuration
      inputs.self.packages.x86_64-linux.fcoury-nvim
    ];

    extraLuaConfig = ''
      -- nvim config
      require 'vim-options'
      require 'neovide'
      require 'keymap'

      -- plugins
      require 'plugins'
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bight_colors = true;
      };
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format="$username$hostname$localip$shlvl$singularity$kubernetes$directory$vcsh$fossil_branch$custom$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$env_var$crystal$sudo$cmd_duration$line_break$jobs$battery$time$status$os$container$shell$character";

      character = {
        error_symbol = "[>](bold yellow) \\$";
        success_symbol = "[>](bold green) \\$";
      };

      username = {
        format = "[$user](bold white)@";
        show_always = true;
      };

      hostname = {
        format = "[$hostname](white) ";
        ssh_only = false;
      };

      package = {
        disabled = true;
      };

      nodejs = {
        format = "[$symbol($version )]($style)";
        symbol = "📦 ";
      };

      rust = {
        format = "[$symbol($version )]($style)";
      };

      lua = {
        format = "[$symbol($version )]($style)";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        modified = "●";
        stashed = "";
        style = "";
        untracked = "!";
      };

      directory = {
        fish_style_pwd_dir_length = 1;
      };

      gcloud = {
        disabled = true;
        format = "[$symbol$account(@$domain)(\($region\))]($style) ";
      };

      aws = {
        disabled = true;
      };

      docker_context = {
        disabled = true;
      };

      custom.gitbranch = {
        symbol = "";
        style = "bold purple";
        shell = "/bin/bash";
        command = ''
          branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
          if [ \$\{#branch} -gt 25 ]; then
              IFS='/' read -ra ADDR <<< \"$branch\"
              if [ \$\{#ADDR[@]} -ge 3 ]; then
                  echo \"\$\{ADDR[0]:0:1}/\$\{ADDR[1]:0:1}/\$\{ADDR[2]}\"
              else
                  echo \"$branch\"
              fi
          else
              echo \"$branch\"
          fi
        '';
        when = "git rev-parse --is-inside-work-tree 2>/dev/null";
        description = "Displays the formatted git branch name";
        format = "on [$symbol ($output )]($style)";
      };
    };
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
