-- Create storage buckets for file uploads
INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('creator-content', 'creator-content', true) ON CONFLICT (id) DO NOTHING;

-- Create policies for avatar uploads
INSERT INTO storage.objects (bucket_id, name, owner, metadata) VALUES ('avatars', '.keep', null, '{}') ON CONFLICT DO NOTHING;
INSERT INTO storage.objects (bucket_id, name, owner, metadata) VALUES ('creator-content', '.keep', null, '{}') ON CONFLICT DO NOTHING;

-- Create policies for avatar storage
CREATE POLICY IF NOT EXISTS "Avatar images are publicly accessible" 
ON storage.objects 
FOR SELECT 
USING (bucket_id = 'avatars');

CREATE POLICY IF NOT EXISTS "Users can upload their own avatar" 
ON storage.objects 
FOR INSERT 
WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY IF NOT EXISTS "Users can update their own avatar" 
ON storage.objects 
FOR UPDATE 
USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY IF NOT EXISTS "Users can delete their own avatar" 
ON storage.objects 
FOR DELETE 
USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Create policies for creator content storage
CREATE POLICY IF NOT EXISTS "Creator content is publicly accessible" 
ON storage.objects 
FOR SELECT 
USING (bucket_id = 'creator-content');

CREATE POLICY IF NOT EXISTS "Users can upload their own content" 
ON storage.objects 
FOR INSERT 
WITH CHECK (bucket_id = 'creator-content' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY IF NOT EXISTS "Users can update their own content" 
ON storage.objects 
FOR UPDATE 
USING (bucket_id = 'creator-content' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY IF NOT EXISTS "Users can delete their own content" 
ON storage.objects 
FOR DELETE 
USING (bucket_id = 'creator-content' AND auth.uid()::text = (storage.foldername(name))[1]);