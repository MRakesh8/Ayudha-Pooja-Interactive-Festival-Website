$source = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;

public class LockKeyer {
    public static void KeyOut(string src, string dst) {
        using (Bitmap b = new Bitmap(src)) {
            int w = b.Width;
            int h = b.Height;
            using (Bitmap res = new Bitmap(w, h, PixelFormat.Format32bppArgb)) {
                bool[,] bg = new bool[w, h];
                Queue<Point> q = new Queue<Point>();

                // Flood fill threshold: pure black background is <= 18
                int bgThreshold = 22;

                // Seeds on exterior borders
                for (int x = 0; x < w; x++) {
                    CheckAndAdd(b, bg, q, x, 0, bgThreshold);
                    CheckAndAdd(b, bg, q, x, h - 1, bgThreshold);
                }
                for (int y = 0; y < h; y++) {
                    CheckAndAdd(b, bg, q, 0, y, bgThreshold);
                    CheckAndAdd(b, bg, q, w - 1, y, bgThreshold);
                }

                // Inner hole seeds
                CheckAndAdd(b, bg, q, w / 2, (int)(h * 0.22), bgThreshold);

                while (q.Count > 0) {
                    Point p = q.Dequeue();
                    int px = p.X;
                    int py = p.Y;

                    CheckAndAdd(b, bg, q, px + 1, py, bgThreshold);
                    CheckAndAdd(b, bg, q, px - 1, py, bgThreshold);
                    CheckAndAdd(b, bg, q, px, py + 1, bgThreshold);
                    CheckAndAdd(b, bg, q, px, py - 1, bgThreshold);
                }

                for (int y = 0; y < h; y++) {
                    for (int x = 0; x < w; x++) {
                        if (bg[x, y]) {
                            res.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                        } else {
                            Color c = b.GetPixel(x, y);
                            bool nearBg = (x > 0 && bg[x-1, y]) || (x < w-1 && bg[x+1, y]) || (y > 0 && bg[x, y-1]) || (y < h-1 && bg[x, y+1]);
                            int lum = (c.R + c.G + c.B) / 3;

                            if (nearBg && lum < 18) {
                                res.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            } else if (nearBg && lum < 45) {
                                int a = Math.Max(0, Math.Min(255, lum * 5));
                                res.SetPixel(x, y, Color.FromArgb(a, c.R, c.G, c.B));
                            } else {
                                res.SetPixel(x, y, Color.FromArgb(255, c.R, c.G, c.B));
                            }
                        }
                    }
                }
                res.Save(dst, ImageFormat.Png);
            }
        }
    }
    static void CheckAndAdd(Bitmap b, bool[,] bg, Queue<Point> q, int x, int y, int threshold) {
        if (x < 0 || x >= b.Width || y < 0 || y >= b.Height || bg[x, y]) return;
        Color c = b.GetPixel(x, y);
        if (c.R <= threshold && c.G <= threshold && c.B <= threshold) {
            bg[x, y] = true;
            q.Enqueue(new Point(x, y));
        }
    }
}
"@
Add-Type -TypeDefinition $source -ReferencedAssemblies "System.Drawing"
$src = (Resolve-Path ".\frontend\assets\antique_temple_padlock_gen.jpg").Path
$dst = (Join-Path (Split-Path $src) "antique_temple_padlock_real.png")
[LockKeyer]::KeyOut($src, $dst)
Write-Output "ACCURATE RESTORATION: $dst"
