-- Insert demo data for new gamification features

-- First, get existing user IDs and create some demo data
DO $$
DECLARE
    user1_id UUID;
    user2_id UUID;
    user3_id UUID;
    admin_id UUID;
BEGIN
    -- Get existing users or create new ones for demo
    SELECT user_id INTO user1_id FROM public.profiles WHERE email = 'emma.creator@demo.com' LIMIT 1;
    SELECT user_id INTO user2_id FROM public.profiles WHERE email = 'alex.gamer@demo.com' LIMIT 1;
    SELECT user_id INTO user3_id FROM public.profiles WHERE email = 'sarah.fitness@demo.com' LIMIT 1;

    -- Create demo admin user data
    INSERT INTO public.profiles (
        user_id, email, full_name, display_name, user_type, is_admin
    ) VALUES (
        gen_random_uuid(), 'admin@vibeMatch.com', 'Admin User', 'Admin', 'sponsor', true
    ) ON CONFLICT (email) DO UPDATE SET is_admin = true
    RETURNING user_id INTO admin_id;

    -- Insert some demo sponsors for matching
    INSERT INTO public.profiles (
        user_id, email, full_name, display_name, bio, tagline, user_type,
        company_name, industry, budget_range, campaign_objectives,
        preferred_sectors, onboarding_completed
    ) VALUES 
    (
        gen_random_uuid(),
        'sponsor1@beautybrand.com',
        'Sophie Martin',
        'BeautyBrand Marketing',
        'Marketing Director at leading beauty brand. Looking for authentic creators for our skincare campaigns.',
        'Authentic beauty, real results 💄',
        'sponsor',
        'BeautyGlow Co.',
        'Beauty & Cosmetics',
        '5000-15000',
        '{"brand_awareness", "product_launch", "user_generated_content"}',
        '{"beauty", "fashion", "lifestyle"}',
        true
    ),
    (
        gen_random_uuid(),
        'sponsor2@techstartup.com', 
        'Marcus Johnson',
        'TechFlow Partnerships',
        'Partnership manager at innovative tech startup. Seeking gaming and tech creators for product collaborations.',
        'Innovation through collaboration 🚀',
        'sponsor',
        'TechFlow Solutions',
        'Technology',
        '10000-30000',
        '{"product_demo", "long_term_partnership", "event_coverage"}',
        '{"gaming", "tech", "entertainment"}',
        true
    ),
    (
        gen_random_uuid(),
        'sponsor3@healthcompany.com',
        'Lisa Rodriguez',
        'WellnessPro Campaigns',
        'Health and wellness company looking for fitness influencers to promote our supplement line.',
        'Wellness for everyone 🌱',
        'sponsor',
        'WellnessPro Inc.',
        'Health & Wellness',
        '3000-12000',
        '{"brand_ambassador", "product_review", "educational_content"}',
        '{"fitness", "health", "nutrition"}',
        true
    ) ON CONFLICT (email) DO NOTHING;

    -- Insert demo ghost profiles
    INSERT INTO public.ghost_profiles (
        discovered_data, compatibility_scores, status
    ) VALUES 
    (
        '{"name": "Jake Fitness Pro", "platform": "instagram", "followers": 150000, "engagement_rate": 4.2, "niche": ["fitness", "nutrition"], "bio": "Personal trainer helping people achieve their fitness goals"}',
        '{"overall": 89, "niche_match": 95, "audience_alignment": 87, "content_quality": 85}',
        'discovered'
    ),
    (
        '{"name": "Maya Beauty Secrets", "platform": "tiktok", "followers": 320000, "engagement_rate": 6.8, "niche": ["beauty", "skincare"], "bio": "Skincare enthusiast sharing daily routines and product reviews"}',
        '{"overall": 92, "niche_match": 90, "audience_alignment": 94, "content_quality": 90}',
        'discovered'
    ),
    (
        '{"name": "Tech Reviewer Tom", "platform": "youtube", "followers": 580000, "engagement_rate": 3.9, "niche": ["tech", "gaming"], "bio": "In-depth tech reviews and gaming content for enthusiasts"}',
        '{"overall": 88, "niche_match": 93, "audience_alignment": 85, "content_quality": 88}',
        'discovered'
    ) ON CONFLICT DO NOTHING;

    -- Insert demo achievements for existing users if they exist
    IF user1_id IS NOT NULL THEN
        INSERT INTO public.achievements (user_id, achievement_type, achievement_data) VALUES
        (user1_id, 'first_match', '{"earned_at": "2024-01-15", "description": "Completed your first successful match!"}'),
        (user1_id, 'profile_optimizer', '{"earned_at": "2024-01-20", "description": "Optimized profile with AI recommendations"}')
        ON CONFLICT (user_id, achievement_type) DO NOTHING;
    END IF;

    IF user2_id IS NOT NULL THEN
        INSERT INTO public.achievements (user_id, achievement_type, achievement_data) VALUES
        (user2_id, 'first_match', '{"earned_at": "2024-01-18", "description": "Completed your first successful match!"}'),
        (user2_id, 'streak_master', '{"earned_at": "2024-01-25", "description": "Maintained a 7-day login streak!"}')
        ON CONFLICT (user_id, achievement_type) DO NOTHING;
    END IF;

    -- Insert demo AI analysis data
    IF user1_id IS NOT NULL THEN
        INSERT INTO public.ai_analysis (profile_id, analysis_data, cerebras_score, analysis_type) VALUES
        (user1_id, '{"strengths": ["High engagement rate", "Niche expertise", "Professional content"], "weaknesses": ["Limited collaboration history"], "recommendations": ["Add more case studies", "Expand content variety"]}', 87.5, 'compatibility'),
        (user1_id, '{"optimization_score": 92, "missing_fields": [], "suggestions": ["Add more recent work examples"]}', 92.0, 'optimization');
    END IF;

    IF user2_id IS NOT NULL THEN
        INSERT INTO public.ai_analysis (profile_id, analysis_data, cerebras_score, analysis_type) VALUES
        (user2_id, '{"strengths": ["Gaming expertise", "Strong community", "Consistent content"], "weaknesses": ["Narrow niche focus"], "recommendations": ["Consider tech reviews", "Expand to streaming"]}', 84.2, 'compatibility');
    END IF;

    -- Insert demo swipe actions if users exist
    IF user1_id IS NOT NULL AND user2_id IS NOT NULL THEN
        -- Get a sponsor user for demo swipes
        INSERT INTO public.swipe_actions (user_id, target_id, action) 
        SELECT user1_id, p.user_id, 'like'
        FROM public.profiles p 
        WHERE p.user_type = 'sponsor' AND p.email = 'sponsor1@beautybrand.com'
        LIMIT 1
        ON CONFLICT (user_id, target_id) DO NOTHING;
        
        INSERT INTO public.swipe_actions (user_id, target_id, action) 
        SELECT user2_id, p.user_id, 'super_like'
        FROM public.profiles p 
        WHERE p.user_type = 'sponsor' AND p.email = 'sponsor2@techstartup.com'
        LIMIT 1
        ON CONFLICT (user_id, target_id) DO NOTHING;
    END IF;

END $$;