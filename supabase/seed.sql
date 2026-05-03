-- commitments table for Real del Monte (and future projects) live tracking
CREATE TABLE IF NOT EXISTS commitments (
  id             BIGSERIAL PRIMARY KEY,
  investor_email TEXT        NOT NULL,
  investor_name  TEXT        NOT NULL,
  amount         NUMERIC     NOT NULL,
  project_name   TEXT        NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE commitments ENABLE ROW LEVEL SECURITY;

-- Dashboard can insert new commitments using the publishable (anon) key
CREATE POLICY "anon_insert" ON commitments
  FOR INSERT TO anon WITH CHECK (true);

-- Dashboard can read all commitments to compute funding progress
CREATE POLICY "anon_select" ON commitments
  FOR SELECT TO anon USING (true);

-- Admin panel can update and delete commitments
CREATE POLICY "anon_update" ON commitments
  FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE POLICY "anon_delete" ON commitments
  FOR DELETE TO anon USING (true);
