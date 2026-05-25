class CascCli < Formula
  desc "A cross-platform CLI tool for Blizzard CASC archives."
  homepage "https://github.com/ironsp4rk/casc-cli"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.6/casc-aarch64-apple-darwin.tar.xz"
      sha256 "c0887d11795e95b47b4eec2e3cc14fbad64569765b01b3dcd301790e2280cb07"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.6/casc-x86_64-apple-darwin.tar.xz"
      sha256 "414959d70dbc0ed0ff38ded483b244ad1d397f33352b5f6a7aeb96f5449f0d65"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.6/casc-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0684670ac8f938786d45586d79aeafdd0b205ab5d6cc75786ab094ef743c2b05"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "casc" if OS.mac? && Hardware::CPU.arm?
    bin.install "casc" if OS.mac? && Hardware::CPU.intel?
    bin.install "casc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
