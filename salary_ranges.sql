-- Run once in the Supabase SQL Editor to enable online salary ranges.
-- Existing salaries remain in the salary column; the new column stores the maximum.
BEGIN;
ALTER TABLE public.job_tracker_applications
  ADD COLUMN IF NOT EXISTS salary_max numeric;
ALTER TABLE public.job_tracker_applications
  DROP CONSTRAINT IF EXISTS job_tracker_salary_range_check;
ALTER TABLE public.job_tracker_applications
  ADD CONSTRAINT job_tracker_salary_range_check
  CHECK (salary_max IS NULL OR
    (salary IS NOT NULL AND salary_max >= salary AND salary_max <= 999999999999));
COMMIT;
NOTIFY pgrst, 'reload schema';
