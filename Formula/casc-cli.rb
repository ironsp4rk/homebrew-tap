class CascCli < Formula
  desc "A cross-platform CLI tool for Blizzard CASC archives."
  homepage "https://github.com/ironsp4rk/casc-cli"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.6/casc-aarch64-apple-darwin.tar.xz"
      sha256 "f49060a1c9136e6fa93cd98ec4ec3a52981e1f7882b8370397eed0403397566f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.6/casc-x86_64-apple-darwin.tar.xz"
      sha256 "ffa87949df46c6f00302a69f923c36ca9636d919d6f1919814ad7b56638529ce"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.6/casc-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9cdc31f7c98a34ca5bb39552bf9b535804fcf57c45685a299d9aa2ae20915089"
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
