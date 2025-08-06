{
  pkgs ? import <nixpkgs> { },
}:


let in

pkgs.mkShell {
  name = "comment-parser";

  buildInputs = with pkgs; [
    shfmt
    pre-commit
  ];

  pre-commit = pkgs.pre-commit;
  shfmt = pkgs.shfmt;

}
