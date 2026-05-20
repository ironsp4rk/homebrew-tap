class CascCli < Formula
  desc "A cross-platform CLI tool for Blizzard CASC archives."
  homepage "https://github.com/ironsp4rk/casc-cli"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.3/casc-aarch64-apple-darwin.tar.xz"
      sha256 "fe31be380538a21bff7f73c1e726336e62ab7d53d578fc445a93c0a9756f75d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.3/casc-x86_64-apple-darwin.tar.xz"
      sha256 "f36bed035f9dd4e32f15c5ef63e3277a9d91dea6acb4671c7d07c23b7af32fa3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/ironsp4rk/casc-cli/releases/download/v0.1.3/casc-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "cb7a7b793a5479dd761a7148ba65dc18ce380f5615aa2aac315a096dc0823bea"
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
