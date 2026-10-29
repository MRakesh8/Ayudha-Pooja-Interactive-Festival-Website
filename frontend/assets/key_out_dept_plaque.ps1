$source = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;

public class PlaqueKeyer {
    public static void KeyOut(string src, string dst) {
        using (Bitmap b = new Bitmap(src)) {
            int w = b.Width;
            int h = b.Height;
            using (Bitmap res = new Bitmap(w, h, PixelFormat.Format32bppArgb)) {
                bool[,] bg = new bool[w, h];
                Queue<Point> q = new Queue<Point>();

                // Seeds on exterior borders with threshold 75 (anything that is not golden/red)
                for (int x = 0; x < w; x++) {
                    CheckAndAdd(b, bg, q, x, 0);
                    CheckAndAdd(b, bg, q, x, h - 1);
                }
                for (int y = 0; y < h; y++) {
                    CheckAndAdd(b, bg, q, 0, y);
                    CheckAndAdd(b, bg, q, w - 1, y);
                }

                while (q.Count > 0) {
                    Point p = q.Dequeue();
                    int px = p.X;
                    int py = p.Y;

                    CheckAndAdd(b, bg, q, px + 1, py);
                    CheckAndAdd(b, bg, q, px - 1, py);
                    CheckAndAdd(b, bg, q, px, py + 1);
                    CheckAndAdd(b, bg, q, px, py - 1);
                }

                for (int y = 0; y < h; y++) {
                    for (int x = 0; x < w; x++) {
                        if (bg[x, y]) {
                            res.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                        } else {
                            Color c = b.GetPixel(x, y);
                            bool nearBg = (x > 0 && bg[x-1, y]) || (x < w-1 && bg[x+1, y]) || (y > 0 && bg[x, y-1]) || (y < h-1 && bg[x, y+1]);
                            int lum = (c.R + c.G + c.B) / 3;

                            if (nearBg && lum < 45) {
                                res.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            } else if (nearBg && lum < 80) {
                                int a = Math.Max(0, Math.Min(255, (lum - 35) * 6));
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
    static void CheckAndAdd(Bitmap b, bool[,] bg, Queue<Point> q, int x, int y) {
        if (x < 0 || x >= b.Width || y < 0 || y >= b.Height || bg[x, y]) return;
        Color c = b.GetPixel(x, y);
        // If not gold/yellow (R is high and G is high):
        bool isGold = (c.R > 130 && c.G > 85 && (c.R - c.B) > 30);
        if (!isGold) {
            bg[x, y] = true;
            q.Enqueue(new Point(x, y));
        }
    }
}
"@

Add-Type -TypeDefinition $source -ReferencedAssemblies "System.Drawing"
$src = "C:\Users\rakes\.gemini\antigravity-ide\brain\48bb4a45-86be-4a0d-a0a4-0212f1a3375e\.user_uploaded\media_1792069637600.png"
$dst = "d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_clean.png"
[PlaqueKeyer]::KeyOut($src, $dst)
Write-Output "Clean transparent department plaque saved to $dst"
