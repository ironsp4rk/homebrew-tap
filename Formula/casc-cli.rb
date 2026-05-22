class CascCli < Formula
  desc "A cross-platform CLI tool for Blizzard CASC archives."
  homepage "https://github.com/ironsp4rk/casc-cli"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.5/casc-aarch64-apple-darwin.tar.xz"
      sha256 "4eb62d1dc5097d1673d039a050f2e0652a46c25200f4a3dd30c63077b8909ba4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.5/casc-x86_64-apple-darwin.tar.xz"
      sha256 "b040815c8efc26aa9b01ac4dae1503da8c625895875446aebbb39b54dd618cc8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.5/casc-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f2aec3be710bf5dc6fadc2af540daedcdfa6abfc3f13b513295bd500a5d567e5"
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
