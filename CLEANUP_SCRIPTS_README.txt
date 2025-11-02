================================================================================
                    SURESEND PROJECT CLEANUP SCRIPTS
================================================================================

Three cleanup scripts are provided to remove documentation and reference files
while keeping only core functional code:

--------------------------------------------------------------------------------
1. cleanup_preview.sh (RECOMMENDED TO RUN FIRST)
--------------------------------------------------------------------------------

   Shows what will be deleted WITHOUT actually deleting anything.

   Usage:
      ./cleanup_preview.sh

   This is a safe way to see exactly what files will be removed before
   proceeding with the actual cleanup.

--------------------------------------------------------------------------------
2. cleanup_project.sh (INTERACTIVE)
--------------------------------------------------------------------------------

   Interactive cleanup script with safety features:
   • Shows preview of files to be deleted
   • Asks for confirmation before proceeding
   • Creates a backup of all deleted files (recommended)
   • Can be cancelled at any time

   Usage:
      ./cleanup_project.sh

   Follow the prompts:
   - Choose whether to create backup (Y/n)
   - Confirm deletion (y/N)

   If backup is created, it will be saved to:
   /tmp/suresend_backup_YYYYMMDD_HHMMSS/

   To restore from backup later:
      cp -r /tmp/suresend_backup_*/* /home/user/suresend/

--------------------------------------------------------------------------------
3. cleanup_project_auto.sh (AUTOMATED)
--------------------------------------------------------------------------------

   Automated cleanup without any prompts or backup.
   Use for CI/CD pipelines or when you're certain you want to clean up.

   ⚠️  WARNING: This script provides no backup and cannot be undone!

   Usage:
      ./cleanup_project_auto.sh

--------------------------------------------------------------------------------
WHAT GETS DELETED
--------------------------------------------------------------------------------

The cleanup removes:
   ✗ All .md files (README, CHANGELOG, guides, documentation)
   ✗ docs/ folder (architecture docs, setup guides, etc.)
   ✗ mobile/assets/ui_references/ folder (reference images - 2MB)
   ✗ Figma attribution and guideline files
   ✗ .gitkeep placeholder files
   ✗ Test documentation files
   ✗ Empty directories

Current total: ~74 files (~2MB)

--------------------------------------------------------------------------------
WHAT GETS KEPT
--------------------------------------------------------------------------------

Everything functional remains:
   ✓ All source code (.dart, .js, .ts, .jsx, .tsx files)
   ✓ Configuration files (pubspec.yaml, package.json, tsconfig.json)
   ✓ App assets used by the application (icons, fonts, images)
   ✓ Build configurations (android/, ios/, web/ folders)
   ✓ Database files and schemas
   ✓ .git folder and git history
   ✓ Dependencies (node_modules, .dart_tool - not deleted)

--------------------------------------------------------------------------------
RECOMMENDED WORKFLOW
--------------------------------------------------------------------------------

Step 1: Preview what will be deleted
   ./cleanup_preview.sh

Step 2: Run interactive cleanup (with backup)
   ./cleanup_project.sh

Step 3: Verify the app still works
   cd mobile && flutter run

Step 4: If something is wrong, restore from backup
   cp -r /tmp/suresend_backup_*/* /home/user/suresend/

Step 5: Delete backup when you're satisfied
   rm -rf /tmp/suresend_backup_*

--------------------------------------------------------------------------------
NOTES
--------------------------------------------------------------------------------

• All scripts must be run from the project root: /home/user/suresend/
• Scripts are already executable (chmod +x has been applied)
• The .git folder is never touched - your git history is safe
• After cleanup, you can still commit changes normally
• To restore individual files from backup, navigate to the backup folder
  and copy specific files back to the project

================================================================================
